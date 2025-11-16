import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/errors/exceptions.dart';
import '../models/location_model.dart';

class LocationService {
  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Check and request location permission
  Future<bool> checkAndRequestPermission() async {
    // Check if location service is enabled
    bool serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationException(
        'Location services are disabled. Please enable location services.',
      );
    }

    // Check permission status
    PermissionStatus permission = await Permission.location.status;

    if (permission.isDenied) {
      // Request permission
      permission = await Permission.location.request();
    }

    if (permission.isPermanentlyDenied) {
      throw LocationException(
        'Location permission is permanently denied. Please enable it in app settings.',
      );
    }

    if (permission.isDenied) {
      throw LocationException('Location permission denied');
    }

    return permission.isGranted;
  }

  /// Get current location
  Future<Location> getCurrentLocation() async {
    try {
      // Check permissions
      final hasPermission = await checkAndRequestPermission();
      if (!hasPermission) {
        throw LocationException('Location permission not granted');
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 30),
      );

      return Location(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } on LocationException {
      rethrow;
    } catch (e) {
      throw LocationException(
        'Failed to get current location: ${e.toString()}',
      );
    }
  }

  /// Get last known location
  Future<Location?> getLastKnownLocation() async {
    try {
      final position = await Geolocator.getLastKnownPosition();
      if (position == null) return null;

      return Location(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      return null;
    }
  }

  /// Calculate distance between two locations in kilometers
  double calculateDistance(Location start, Location end) {
    return Geolocator.distanceBetween(
          start.latitude,
          start.longitude,
          end.latitude,
          end.longitude,
        ) /
        1000; // Convert meters to kilometers
  }

  /// Open location settings
  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  /// Open app settings
  Future<void> openAppSettings() async {
    await openAppSettings();
  }
}
