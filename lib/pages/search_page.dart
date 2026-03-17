import 'dart:async';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../l10n/generated/app_localizations.dart';

import '../models/school.dart';
import '../providers/favorites_provider.dart';
import '../providers/search_provider.dart';
import '../services/location_service.dart';
import '../widgets/map_component.dart';
import '../widgets/school_list_item.dart';
import '../widgets/search_bar.dart';
import 'advanced_search_page.dart';
import 'school_details_page.dart';

/// Search page with search bar, result map, and results list.
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final LocationService _locationService = LocationService();
  LatLng _mapCenter = LocationService.defaultLocation;
  final double _mapZoom = 13;
  // Key to access MapComponent state for imperative camera moves
  final GlobalKey _mapKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    unawaited(_initMapCenter());
  }

  Future<void> _initMapCenter() async {
    final locationService = LocationService();
    final location = await locationService.getCurrentLocation();
    setState(() {
      _mapCenter = location;
    });
  }

  void _onSearch(String query) {
    final search = context.read<SearchProvider>();
    unawaited(search.searchBasic(query));
  }

  Future<void> _openAdvancedSearch() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(builder: (context) => const AdvancedSearchPage()),
    );

    // If advanced search was applied, results are already in SearchProvider
    if (result ?? false) {
      _updateMapCenter();
    }
  }

  void _updateMapCenter() {
    final search = context.read<SearchProvider>();
    if (search.results.isNotEmpty) {
      // Center map on first result
      final first = search.results.first;
      setState(() {
        _mapCenter = LatLng(first.latitude, first.longitude);
      });
    }
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

  Future<void> _onRecenter() async {
    final location = await _locationService.getCurrentLocation();
    setState(() {
      _mapCenter = location;
    });

    // Imperatively move the map controller if available and reset rotation.
    try {
      final state = _mapKey.currentState;
      // Use dynamic to avoid referencing private state type.
      (state as dynamic)?.moveTo(location, zoom: _mapZoom, rotation: 0);
    } catch (_) {
      // Ignore: if moveTo isn't available, the rebuild will handle it.
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final search = context.watch<SearchProvider>();
    final favorites = context.watch<FavoritesProvider>();

    return Column(
      children: [
        // Map showing search results
        Expanded(
          flex: 35,
          child: MapComponent(
            key: _mapKey,
            center: _mapCenter,
            zoom: _mapZoom,
            schools: search.results,
            onSchoolTap: _navigateToDetails,
            showRecenterButton: true,
            onRecenter: _onRecenter,
          ),
        ),

        // Search bar
        AppSearchBar(
          onSearch: _onSearch,
          onFilterTap: _openAdvancedSearch,
          initialQuery: search.lastQuery,
        ),

        const Divider(height: 1),

        // Search results list
        Expanded(
          flex: 55,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (search.lastQuery.isNotEmpty || search.results.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Text(
                    '${l10n.searchResults} (${search.results.length})',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              Expanded(
                child: search.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : search.results.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search,
                              size: 64,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              search.lastQuery.isEmpty
                                  ? l10n.enterKeywordToSearch
                                  : l10n.noResultsFound,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: search.results.length,
                        itemBuilder: (context, index) {
                          final school = search.results[index];
                          return SchoolListItem(
                            school: school,
                            isFavorite: favorites.isFavorite(school.id.toInt()),
                            onTap: () => _navigateToDetails(school),
                            onFavoriteToggle: () {
                              unawaited(favorites.toggleFavorite(school));
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
