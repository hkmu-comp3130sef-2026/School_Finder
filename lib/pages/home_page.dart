import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../l10n/generated/app_localizations.dart';

import '../models/school.dart';
import '../providers/favorites_provider.dart';
import '../services/location_service.dart';
import '../services/native_bridge.dart';
import '../widgets/map_component.dart';
import '../widgets/school_list_item.dart';
import 'school_details_page.dart';

/// Home page with map and nearby schools list.
///
/// Map occupies ~40-50% of screen, list below.
/// Recenter button returns to GPS location preserving zoom.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LocationService _locationService = LocationService();

  LatLng _currentCenter = LocationService.defaultLocation;
  double _currentZoom = 14;
  bool _isLoading = true;
  bool _hasTriedSync = false; // Track if we've attempted to sync data
  bool _isSyncing = false; // Track if a sync is in progress

  // Backend data for display
  List<SchoolWithDistance> _nearbySchools = [];
  Timer? _debounceTimer;

  // SWR Cache: Key -> List of schools
  final Map<String, List<SchoolWithDistance>> _schoolCache = {};

  @override
  void initState() {
    super.initState();
    unawaited(_initLocation());
  }

  Future<void> _initLocation() async {
    final location = await _locationService.getCurrentLocation();
    setState(() {
      _currentCenter = location;
      _isLoading = false;
    });
    unawaited(_loadNearbySchools());
  }

  Future<void> _loadNearbySchools() async {
    // 1. Calculate parameters and cache key
    final range = calculateRange(_currentZoom);
    final cacheKey = getCacheKey(
      _currentCenter.latitude,
      _currentCenter.longitude,
      range,
    );

    // 2. Optimistic Update (Stale)
    if (_schoolCache.containsKey(cacheKey)) {
      debugPrint('SWR: Cache hit for $cacheKey, showing optimistic results');
      setState(() {
        _nearbySchools = _schoolCache[cacheKey]!;
        _isLoading = false;
      });
    }

    try {
      if (!await NativeBridge().isAvailable()) {
        debugPrint('NativeBridge not available, skipping fetch');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final request = RangeSearchRequest(
        userLatitude: _currentCenter.latitude,
        userLongitude: _currentCenter.longitude,
        range: range,
      );

      final responseBytes = await NativeBridge().call(
        BridgeAction.getNearbySchools,
        request,
      );

      if (responseBytes == null) {
        debugPrint('Bridge returned null response');
        return;
      }

      final response = await (Platform.environment.containsKey('FLUTTER_TEST')
          ? Future.value(parseRangeSearchResponse(responseBytes))
          : compute(parseRangeSearchResponse, responseBytes));

      debugPrint(
        'Got ${response.schools.length} schools from backend at (${_currentCenter.latitude}, ${_currentCenter.longitude})',
      );

      // If response is empty and we haven't tried syncing yet, trigger data sync
      if (response.schools.isEmpty && !_hasTriedSync && !_isSyncing) {
        _hasTriedSync = true;
        await _syncDataFromRemote();
        return; // _syncDataFromRemote will call _loadNearbySchools again
      }

      // 3. Update Cache (Revalidate)
      if (mounted) {
        setState(() {
          final newSchools = response.schools
              .map(SchoolWithDistance.fromProto)
              .toList();

          _schoolCache[cacheKey] = newSchools;
          _nearbySchools = newSchools;
          _isLoading = false;
        });
      }
    } on Exception catch (e) {
      debugPrint('Error loading schools: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Syncs school data from remote URL (first-time setup)
  Future<void> _syncDataFromRemote() async {
    if (_isSyncing) return;

    setState(() {
      _isSyncing = true;
      _isLoading = true;
    });

    try {
      debugPrint('Database empty, syncing data from remote...');
      await NativeBridge().call(BridgeAction.reloadData);
      debugPrint('Data sync completed successfully');

      // Reload nearby schools after sync
      if (mounted) {
        await _loadNearbySchools();
      }
    } on Exception catch (e) {
      debugPrint('Error syncing data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load school data: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSyncing = false;
          _isLoading = false;
        });
      }
    }
  }

  void _onCameraChange(LatLng center, double zoom) {
    setState(() {
      _currentCenter = center;
      _currentZoom = zoom;
    });

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        unawaited(_loadNearbySchools());
      }
    });
  }

  Future<void> _onRecenter() async {
    final location = await _locationService.getCurrentLocation();
    setState(() {
      _currentCenter = location;
      // Preserve current zoom level
    });
    unawaited(_loadNearbySchools());
  }

  void _navigateToDetails(School school) {
    unawaited(
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => SchoolDetailsPage(school: school),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // Map section (40-50% of screen)
        Expanded(
          flex: 45,
          child: MapComponent(
            center: _currentCenter,
            zoom: _currentZoom,
            schools: _nearbySchools.map((s) => s.school).toList(),
            onCameraChange: _onCameraChange,
            onSchoolTap: _navigateToDetails,
            showRecenterButton: true,
            onRecenter: _onRecenter,
          ),
        ),

        const Divider(height: 1),

        // Nearby schools list section
        Expanded(
          flex: 55,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  l10n.nearbySchools,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Expanded(
                child: _nearbySchools.isEmpty
                    ? Center(
                        child: Text(
                          l10n.noSchoolsNearby,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      )
                    : ListView.builder(
                        itemCount: _nearbySchools.length,
                        itemBuilder: (context, index) {
                          final item = _nearbySchools[index];
                          return Selector<FavoritesProvider, bool>(
                            selector: (context, provider) =>
                                provider.isFavorite(item.school.id.toInt()),
                            builder: (context, isFavorite, child) {
                              return SchoolListItem(
                                school: item.school,
                                distance: item.distance,
                                isFavorite: isFavorite,
                                onTap: () => _navigateToDetails(item.school),
                                onFavoriteToggle: () {
                                  unawaited(
                                    context
                                        .read<FavoritesProvider>()
                                        .toggleFavorite(item.school),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Calculates search radius in meters based on zoom level.
@visibleForTesting
double calculateRange(double zoom) {
  // Target: 5000m at Zoom 14
  // C = 5000 * 2^14 = 81,920,000
  const double baseConstant = 81920000;

  // Use pow(2, zoom) to handle fractional zoom levels smoothly
  final radius = baseConstant / pow(2, zoom);

  // Clamp to reasonable limits (100m to 50km)
  return radius.clamp(100, 50000);
}

/// Generates a cache key based on location and range.
/// Quantizes coordinates to ~100m (3 decimal places) to group nearby lookups.
@visibleForTesting
String getCacheKey(double lat, double lng, double range) {
  return '${lat.toStringAsFixed(3)}_${lng.toStringAsFixed(3)}_${range.toInt()}';
}

// Top-level function for isolate
RangeSearchResponse parseRangeSearchResponse(Uint8List bytes) {
  return RangeSearchResponse.fromBuffer(bytes);
}
