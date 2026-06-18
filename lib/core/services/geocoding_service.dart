import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_kishan/core/config/map_constants.dart';

/// Reverse-geocoding via OpenStreetMap Nominatim (free, no API key).
/// Turns coordinates into a human-readable address string. Reused anywhere we
/// fetch a location and want to show/store its name: farmland, subsidies,
/// marketplace listings, delivery addresses, etc.
///
/// Nominatim usage policy: send a descriptive User-Agent and don't hammer it
/// (max ~1 req/sec). We use it only on explicit user action (button tap), so
/// we stay well within limits.
class GeocodingService {
  GeocodingService({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  static const _base = MapConstants.nominatimBase;

  /// Returns a formatted address for the coordinates, or null on failure.
  /// [lang] picks the response language ('en' or 'ne' — Nominatim supports
  /// Nepali display names where available).
  Future<String?> addressFromLatLng(
    double lat,
    double lng, {
    String lang = 'en',
  }) async {
    try {
      final res = await _dio.get(
        _base,
        queryParameters: {
          'lat': lat,
          'lon': lng,
          'format': 'json',
          'accept-language': lang,
          'zoom': 16, // street/neighbourhood level
        },
        options: Options(
          headers: {
            // Required by Nominatim's usage policy.
            'User-Agent': 'SmartKishan/1.0 (farming app)',
          },
        ),
      );

      final data = res.data;
      if (data is Map<String, dynamic>) {
        // 'display_name' is the full human-readable address.
        final display = data['display_name'];
        if (display is String && display.isNotEmpty) return display;
      }
      return null;
    } catch (e) {
      debugPrint('Reverse geocoding failed: $e');
      return null;
    }
  }

  /// A shorter address (skips the country/postcode tail). Builds from the
  /// structured `address` object Nominatim returns, falling back to a trimmed
  /// display_name. Useful where the full string is too long for a field.
  Future<String?> shortAddressFromLatLng(
    double lat,
    double lng, {
    String lang = 'en',
  }) async {
    try {
      final res = await _dio.get(
        _base,
        queryParameters: {
          'lat': lat,
          'lon': lng,
          'format': 'json',
          'accept-language': lang,
          'zoom': 16,
          'addressdetails': 1,
        },
        options: Options(
          headers: {'User-Agent': 'SmartKishan/1.0 (farming app)'},
        ),
      );

      final data = res.data;
      if (data is Map<String, dynamic>) {
        final addr = data['address'];
        if (addr is Map<String, dynamic>) {
          // Pick the most useful parts, nearest-first.
          final parts = <String>[
            for (final key in [
              'village',
              'suburb',
              'neighbourhood',
              'town',
              'city',
              'municipality',
              'county',
              'state_district',
              'state',
            ])
              if (addr[key] is String && (addr[key] as String).isNotEmpty)
                addr[key] as String,
          ];
          // De-dupe consecutive repeats, take the first 3 meaningful parts.
          final seen = <String>{};
          final picked = parts.where(seen.add).take(3).toList();
          if (picked.isNotEmpty) return picked.join(', ');
        }
        final display = data['display_name'];
        if (display is String && display.isNotEmpty) return display;
      }
      return null;
    } catch (e) {
      debugPrint('Reverse geocoding (short) failed: $e');
      return null;
    }
  }
}
