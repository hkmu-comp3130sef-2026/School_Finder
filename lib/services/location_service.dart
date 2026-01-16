import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

/// Service for handling GPS location functionality.
class LocationService {
  // Default location: Hong Kong Metropolitan University
  static const LatLng defaultLocation = LatLng(22.31636, 114.18018);

  // Singleton instance
  static final LocationService _instance = LocationService._internal();

  factory LocationService() => _instance;

  LocationService._internal();

  /// Gets the current user location.
  ///
  /// Returns the current GPS position if available and permitted,
  /// otherwise returns the default location.
  Future<LatLng> getCurrentLocation() async {
    try {
      final hasPermission = await _checkAndRequestPermission();
      if (!hasPermission) {
        return defaultLocation;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      return LatLng(position.latitude, position.longitude);
    } on Exception catch (_) {
      // Return default location on any error
      return defaultLocation;
    }
  }

  /// Checks if location services are enabled and has permission.
  Future<bool> hasLocationPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  /// Checks and requests location permission if needed.
  /// Returns true if permission is granted.
  Future<bool> _checkAndRequestPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  /// Calculates distance between two points in meters.
  double calculateDistance(LatLng from, LatLng to) {
    return Geolocator.distanceBetween(
      from.latitude,
      from.longitude,
      to.latitude,
      to.longitude,
    );
  }

  /// Opens the app settings for location permission.
  Future<bool> openAppSettings() {
    return Geolocator.openAppSettings();
  }

  /// Opens location settings.
  Future<bool> openLocationSettings() {
    return Geolocator.openLocationSettings();
  }
}
