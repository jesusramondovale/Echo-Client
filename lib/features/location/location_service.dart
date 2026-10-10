import 'package:geolocator/geolocator.dart';

class LocationFix {
  LocationFix({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.timestamp,
  });

  final double latitude;
  final double longitude;
  final double accuracy;
  final DateTime timestamp;
}

enum LocationAccessResult {
  granted,
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
}

class LocationService {
  Future<bool> ensurePermission() async {
    final result = await requestAccess(openSettingsIfNeeded: false);
    return result == LocationAccessResult.granted;
  }

  /// Requests location permission and, when needed, opens system settings
  /// so the user can enable GPS or unlock app permission.
  Future<LocationAccessResult> requestAccess({
    bool openSettingsIfNeeded = true,
  }) async {
    var serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (openSettingsIfNeeded) {
        await Geolocator.openLocationSettings();
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
      }
      if (!serviceEnabled) {
        return LocationAccessResult.serviceDisabled;
      }
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      if (openSettingsIfNeeded) {
        await Geolocator.openAppSettings();
        permission = await Geolocator.checkPermission();
      }
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        return LocationAccessResult.permissionDeniedForever;
      }
    }

    if (permission == LocationPermission.denied) {
      return LocationAccessResult.permissionDenied;
    }

    return LocationAccessResult.granted;
  }

  Future<LocationFix> currentFix() async {
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 20),
      ),
    );
    return LocationFix(
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
      timestamp: position.timestamp,
    );
  }
}
