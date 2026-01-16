import 'dart:async';
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

/// Favorites page with persisted map and favorites list.
///
/// Map shows all favorite schools. Map state is persisted via backend.
/// GPS priority for initial center, falls back to saved state.
class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final LocationService _locationService = LocationService();

  LatLng _currentCenter = LocationService.defaultLocation;
  double _currentZoom = 12;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    unawaited(_initMapState());
  }

  Future<void> _initMapState() async {
    // Try GPS first
    final hasGps = await _locationService.hasLocationPermission();

    if (hasGps) {
      if (!mounted) return;
      final location = await _locationService.getCurrentLocation();
      if (!mounted) return;
      setState(() {
        _currentCenter = location;
        _isLoading = false;
      });
    } else {
      // Fall back to saved map state
      try {
        if (await NativeBridge().isAvailable()) {
          final responseBytes = await NativeBridge().call(
            BridgeAction.getMapState,
          );

          if (responseBytes != null) {
            if (!mounted) return;
            final mapState = MapState.fromBuffer(responseBytes);
            setState(() {
              _currentCenter = LatLng(
                mapState.centerLatitude,
                mapState.centerLongitude,
              );
              _currentZoom = mapState.zoomLevel;
            });
          }
        }
      } on Exception catch (e) {
        debugPrint('Failed to load map state: $e');
      }

      setState(() {
        _isLoading = false;
      });
    }

    // Load favorites
    if (mounted) {
      final favorites = context.read<FavoritesProvider>();
      await favorites.loadFavorites();
    }
  }

  void _onCameraChange(LatLng center, double zoom) {
    setState(() {
      _currentCenter = center;
      _currentZoom = zoom;
    });

    // Save map state (debounced by MapComponent)
    unawaited(
      NativeBridge().isAvailable().then((available) {
        if (available) {
          final request = MapState(
            centerLatitude: center.latitude,
            centerLongitude: center.longitude,
            zoomLevel: zoom,
          );
          unawaited(NativeBridge().call(BridgeAction.saveMapState, request));
        }
      }),
    );
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

  Future<void> _removeFavorite(
    FavoritesProvider favorites,
    School school,
  ) async {
    final removed = await favorites.removeFavorite(school.id.toInt());
    if (!mounted) return;
    if (removed != null) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.removedFromFavorites),
          action: SnackBarAction(
            label: l10n.actionUndo,
            onPressed: () {
              unawaited(favorites.restoreFavorite(removed));
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final favorites = context.watch<FavoritesProvider>();

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // Map section showing all favorites
        Expanded(
          flex: 45,
          child: MapComponent(
            center: _currentCenter,
            zoom: _currentZoom,
            schools: favorites.favorites,
            onCameraChange: _onCameraChange,
            onSchoolTap: _navigateToDetails,
          ),
        ),

        const Divider(height: 1),

        // Favorites list section
        Expanded(
          flex: 55,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  l10n.favoriteSchools,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Expanded(
                child: favorites.favorites.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.star_border,
                              size: 64,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.noFavoritesYet,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: favorites.favorites.length,
                        itemBuilder: (context, index) {
                          final school = favorites.favorites[index];
                          return SchoolListItem(
                            school: school,
                            isFavorite: true,
                            onTap: () => _navigateToDetails(school),
                            onFavoriteToggle: () {
                              unawaited(_removeFavorite(favorites, school));
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
