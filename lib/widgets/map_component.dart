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
  // Track desired rotation (north-up = 0.0). Stored so callers can request
  // rotation even if the underlying MapController API doesn't support it yet.
  double _rotation = 0.0;

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

    // Update current rotation from controller so the compass UI can reflect it.
    try {
      final currentRotation = _mapController.camera.rotation;
      if ((currentRotation - _rotation).abs() > 1e-3) {
        _rotation = currentRotation;
        if (mounted) setState(() {});
      }
    } catch (_) {
      // ignore if camera not ready yet
    }

    // Only respond to move end events for camera change callback
    if (event is MapEventMoveEnd) {
      if (widget.onCameraChange == null) return;
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

        // Recenter button: always shown when requested and resets to initial center/zoom.
        if (widget.showRecenterButton)
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton.small(
              heroTag: 'map_recenter',
              onPressed: _handleRecenterPressed,
              child: const Icon(Icons.my_location),
            ),
          ),
        // Compass showing current rotation (north-up when rotation == 0).
        Positioned(
          right: 16,
          bottom: 86,
          child: GestureDetector(
            onTap: () {
              // Reset stored rotation to north-up. If map supports rotation,
              // this would apply it programmatically.
              setState(() {
                _rotation = 0.0;
              });
            },
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 4,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Transform.rotate(
                angle: _rotationRadians(),
                child: Icon(
                  Icons.navigation,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Moves the map camera to a new position.
  void moveTo(LatLng position, {double? zoom, double? rotation}) {
    // Store requested rotation for future use; currently flutter_map's
    // MapController.move doesn't accept a rotation parameter, so we only
    // persist it here for callers that expect a rotation argument.
    if (rotation != null) _rotation = rotation;
    _mapController.move(position, zoom ?? _mapController.camera.zoom);
  }

  double _rotationRadians() {
    // Detect whether stored rotation looks like degrees (> 2*pi) and
    // convert to radians for `Transform.rotate`. Otherwise assume radians.
    const pi = 3.141592653589793;
    if (_rotation.abs() > 2 * pi) {
      return _rotation * (pi / 180.0);
    }
    return _rotation;
  }

  /// Handler for recenter button. Resets to the widget's initial center/zoom
  /// and then invokes the optional external callback.
  void _handleRecenterPressed() {
    // Reset stored rotation to north-up and move camera. If/when the map
    // controller supports programmatic rotation, apply `_rotation` here.
    _rotation = 0.0;
    _mapController.move(widget.center, widget.zoom);
    widget.onRecenter?.call();
  }
}