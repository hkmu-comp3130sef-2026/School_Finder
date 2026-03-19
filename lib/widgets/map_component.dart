import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';

import '../models/school.dart';

/// Modes for the compass/map rotation
enum CompassMode {
  free, // Map doesn't rotate automatically
  gyro, // Map rotates with device heading
  northUp, // Map is fixed to North (0 rotation)
}

/// Reusable map component wrapper around flutter_map.
///
/// Supports interactive and static modes, school pin markers,
/// and camera change callbacks with optional debounce.
class MapComponent extends StatefulWidget {
  /// External MapController provided by the parent.
  final MapController? mapController;

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

  const MapComponent({
    required this.center,
    super.key,
    this.mapController,
    this.zoom = 14,
    this.interactive = true,
    this.schools = const [],
    this.selectedSchool,
    this.onSchoolTap,
    this.onCameraChange,
    this.debounceDuration = const Duration(milliseconds: 200),
    this.showRecenterButton = false,
  });

  @override
  State<MapComponent> createState() => _MapComponentState();
}

class _MapComponentState extends State<MapComponent> {
  late final MapController _mapController;
  Timer? _debounceTimer;

  CompassMode _compassMode = CompassMode.northUp;
  AlignOnUpdate _alignPositionOnUpdate = AlignOnUpdate.never;
  AlignOnUpdate _alignDirectionOnUpdate = AlignOnUpdate.never;
  double _currentRotation = 0;

  // Stream controllers for location marker
  late StreamController<double?> _alignPositionStreamController;
  late StreamController<void> _alignDirectionStreamController;

  @override
  void initState() {
    super.initState();
    _mapController = widget.mapController ?? MapController();
    _alignPositionStreamController = StreamController<double?>.broadcast();
    _alignDirectionStreamController = StreamController<void>.broadcast();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    // StreamController.close() returns a Future but we don't need to await it in dispose
    _alignPositionStreamController.close(); // ignore: discarded_futures
    // StreamController.close() returns a Future but we don't need to await it in dispose
    _alignDirectionStreamController.close(); // ignore: discarded_futures
    if (widget.mapController == null) {
      _mapController.dispose();
    }
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

    if (event is MapEventMove && event.source != MapEventSource.mapController) {
      if (_alignPositionOnUpdate != AlignOnUpdate.never) {
        setState(() {
          _alignPositionOnUpdate = AlignOnUpdate.never;
        });
      }
    }

    if (event is MapEventRotate &&
        event.source != MapEventSource.mapController) {
      _currentRotation = event.camera.rotation;
      if (_compassMode != CompassMode.free) {
        setState(() {
          _compassMode = CompassMode.free;
          _alignDirectionOnUpdate = AlignOnUpdate.never;
        });
      } else {
        setState(() {});
      }
    }

    if (event is MapEventMove) {
      _currentRotation = event.camera.rotation;
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

  void _toggleCompassMode() {
    setState(() {
      switch (_compassMode) {
        case CompassMode.northUp:
          // Switch to Gyro
          _compassMode = CompassMode.gyro;
          _alignDirectionOnUpdate = AlignOnUpdate.always;
        case CompassMode.gyro:
          // Switch to Free
          _compassMode = CompassMode.free;
          _alignDirectionOnUpdate = AlignOnUpdate.never;
        case CompassMode.free:
          // Switch to NorthUp
          _compassMode = CompassMode.northUp;
          _alignDirectionOnUpdate = AlignOnUpdate.never;
          _mapController.rotate(0);
      }
    });
    // Trigger direction update when entering gyro mode
    if (_compassMode == CompassMode.gyro) {
      _alignDirectionStreamController.add(null);
    }
  }

  void _handleRecenterPressed() {
    setState(() {
      _alignPositionOnUpdate = AlignOnUpdate.always;
    });
    // Trigger alignment
    _alignPositionStreamController.add(widget.zoom);
  }

  Widget _buildCompassButton(ThemeData theme) {
    IconData icon;
    Color color;

    switch (_compassMode) {
      case CompassMode.northUp:
        icon = Icons.navigation;
        color = theme.colorScheme.primary;
      case CompassMode.gyro:
        icon = Icons.explore;
        color = theme.colorScheme.secondary;
      case CompassMode.free:
        icon = Icons.navigation_outlined;
        color = theme.colorScheme.onSurface;
    }

    return GestureDetector(
      onTap: _toggleCompassMode,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 4,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Transform.rotate(
          angle: -_currentRotation * (math.pi / 180.0),
          child: Icon(icon, size: 20, color: color),
        ),
      ),
    );
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

            CurrentLocationLayer(
              alignPositionStream: _alignPositionStreamController.stream,
              alignPositionOnUpdate: _alignPositionOnUpdate,
              alignDirectionStream: _alignDirectionStreamController.stream,
              alignDirectionOnUpdate: _alignDirectionOnUpdate,
              style: const LocationMarkerStyle(
                marker: DefaultLocationMarker(
                  color: Colors.blue,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
                markerSize: Size(24, 24),
                markerDirection: MarkerDirection.heading,
              ),
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
        if (widget.showRecenterButton)
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton.small(
              heroTag: 'map_recenter',
              onPressed: _handleRecenterPressed,
              child: Icon(
                _alignPositionOnUpdate == AlignOnUpdate.always
                    ? Icons.my_location
                    : Icons.location_searching,
                color: _alignPositionOnUpdate == AlignOnUpdate.always
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
              ),
            ),
          ),

        // Compass button
        Positioned(
          left: 16,
          top: 16,
          child: _buildCompassButton(theme),
        ),
      ],
    );
  }
}
