import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

/// Wraps geolocator. Permission is requested once at app launch (see
/// LocationService.ensurePermission called from bootstrap), so screens just
/// call currentLatLng(). On a simulator / when location is unavailable, falls
/// back to default coordinates (Kathmandu) so the soil flow still works.
class LocationService {
  // Simulator / fallback coordinates (Kathmandu valley).
  static const double _fallbackLat = 27.7172;
  static const double _fallbackLng = 85.3240;
  // Simulator / fallback coordinates (Terai crop area).
  static const double _fallbackLatCrop = 28.5737;
  static const double _fallbackLngCrop = 80.8068;

  /// Dev override — when true, always return fallback coords (skip real GPS).
  /// Set from a debug toggle, or use kDebugMode + an env flag.
  bool useFallbackOverride = true;

  /// Request permission + enable check. Call ONCE at app launch.
  Future<void> ensurePermission() async {
    try {
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) return;
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
    } catch (e) {
      debugPrint('Location permission error: $e');
    }
  }

  /// Best-effort current location. Returns fallback coords if anything fails
  /// (simulator, denied, timeout) so the caller always gets usable values.
  Future<({double lat, double lng})> currentLatLng() async {
    if (useFallbackOverride) {
      return (lat: _fallbackLatCrop, lng: _fallbackLngCrop);
    }
    try {
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) return (lat: _fallbackLat, lng: _fallbackLng);

      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        return (lat: _fallbackLat, lng: _fallbackLng);
      }

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
      return (lat: pos.latitude, lng: pos.longitude);
    } catch (e) {
      debugPrint('currentLatLng failed, using fallback: $e');
      return (lat: _fallbackLat, lng: _fallbackLng);
    }
  }
}
