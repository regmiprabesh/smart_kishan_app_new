import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smart_kishan/core/config/map_constants.dart';

/// Wraps geolocator. Permission is requested once at app launch (see
/// [ensurePermission], called from bootstrap), so screens just call
/// [currentLatLng]. When location is unavailable (denied, disabled, timeout)
/// it falls back to [MapConstants.fallbackCenter] so callers always get
/// usable coordinates.
class LocationService {
  /// Debug-only escape hatch: when true AND in a debug build, skip GPS and
  /// return the fallback immediately (handy on a simulator). NEVER affects
  /// release builds. Defaults off.
  bool debugUseFallback = false;

  /// Single source of truth for fallback coordinates.
  ({double lat, double lng}) get _fallback => (
    lat: MapConstants.fallbackCenter.latitude,
    lng: MapConstants.fallbackCenter.longitude,
  );

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

  /// Best-effort current location. Returns [MapConstants.fallbackCenter] if
  /// anything fails so the caller always gets usable values.
  Future<({double lat, double lng})> currentLatLng() async {
    if (kDebugMode && debugUseFallback) return _fallback;
    try {
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) return _fallback;

      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        return _fallback;
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
      return _fallback;
    }
  }
}
