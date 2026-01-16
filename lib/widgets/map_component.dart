import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/school.dart';

/// Reusable map component wrapper around flutter_map.
///
/// Supports interactive and static modes, school pin markers,
/// and camera change callbacks with optional debounce.
class MapComponent extends StatefulWidget {
  /// Initial center position.
  final LatLng center;

  /// Initial zoom level.
  final double zoom;

  /// Whether the map is interactive (draggable/zoomable).
  final bool interactive;

  /// Schools to display as markers.
  final List<School> schools;

  /// Currently selected school (for highlighting).
  final School? selectedSchool;

  /// Callback when a school marker is tapped.
  final void Function(School school)? onSchoolTap;

  /// Callback when the camera position changes.
  /// Called with debounce if enabled.
  final void Function(LatLng center, double zoom)? onCameraChange;

  /// Debounce duration for camera change callbacks.
  final Duration debounceDuration;

  /// Whether to show a recenter button.
  final bool showRecenterButton;

  /// Callback when recenter button is tapped.
  final VoidCallback? onRecenter;

  const MapComponent({
    required this.center,
    super.key,
    this.zoom = 14,
    this.interactive = true,
    this.schools = const [],
    this.selectedSchool,
    this.onSchoolTap,
    this.onCameraChange,
    this.debounceDuration = const Duration(milliseconds: 200),
    this.showRecenterButton = false,
    this.onRecenter,
  });

  @override
  State<MapComponent> createState() => _MapComponentState();
}

class _MapComponentState extends State<MapComponent> {
  late final MapController _mapController;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(MapComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Move camera if center changed externally
    if (oldWidget.center != widget.center) {
      _mapController.move(widget.center, widget.zoom);
    }
  }

  void _onMapEvent(MapEvent event) {
    if (!widget.interactive) return;
    if (widget.onCameraChange == null) return;

    // Only respond to move end events
    if (event is MapEventMoveEnd) {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(widget.debounceDuration, () {
        if (!mounted) return;
        final center = _mapController.camera.center;
        final zoom = _mapController.camera.zoom;
        widget.onCameraChange?.call(center, zoom);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: widget.center,
            initialZoom: widget.zoom,
            interactionOptions: InteractionOptions(
              flags: widget.interactive
                  ? InteractiveFlag.all
                  : InteractiveFlag.none,
            ),
            onMapEvent: _onMapEvent,
          ),
          children: [
            // OpenStreetMap tile layer
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.school.finder',
            ),

            // School markers
            MarkerLayer(
              markers: widget.schools.map((school) {
                final isSelected = widget.selectedSchool?.id == school.id;
                return Marker(
                  point: LatLng(school.latitude, school.longitude),
                  width: 40,
                  height: 40,
                  child: GestureDetector(
                    onTap: () => widget.onSchoolTap?.call(school),
                    child: Icon(
                      Icons.location_pin,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.error,
                      size: isSelected ? 40 : 32,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),

        // Recenter button
        if (widget.showRecenterButton && widget.onRecenter != null)
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton.small(
              heroTag: 'map_recenter',
              onPressed: widget.onRecenter,
              child: const Icon(Icons.my_location),
            ),
          ),
      ],
    );
  }

  /// Moves the map camera to a new position.
  void moveTo(LatLng position, {double? zoom}) {
    _mapController.move(position, zoom ?? _mapController.camera.zoom);
  }
}
