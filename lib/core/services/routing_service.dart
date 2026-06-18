import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:smart_kishan/core/config/map_constants.dart';

/// Driving directions via OSRM's public demo server (free, no API key).
/// Returns the decoded polyline as a list of [LatLng] for a flutter_map
/// [Polyline], or null if the route can't be fetched (the caller just skips
/// drawing the line — non-fatal).
///
/// NOTE: router.project-osrm.org is a public demo endpoint with no SLA. For
/// production traffic, self-host OSRM or swap to a keyed provider — this class
/// is the single seam where that change lives.
class RoutingService {
  static const _base = MapConstants.osrmBase;

  Future<List<LatLng>?> getRoute(LatLng start, LatLng end) async {
    try {
      final url = Uri.parse(
        '$_base/'
        '${start.longitude},${start.latitude};'
        '${end.longitude},${end.latitude}'
        '?overview=full&geometries=geojson',
      );

      final res = await http.get(url);
      if (res.statusCode != 200) return null;

      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final routes = data['routes'] as List?;
      if (routes == null || routes.isEmpty) return null;

      // GeoJSON coordinates are [lng, lat] — swap to LatLng(lat, lng).
      final coords = routes.first['geometry']['coordinates'] as List;
      return coords
          .map(
            (c) => LatLng((c[1] as num).toDouble(), (c[0] as num).toDouble()),
          )
          .toList();
    } catch (e) {
      debugPrint('RoutingService.getRoute failed: $e');
      return null;
    }
  }
}
