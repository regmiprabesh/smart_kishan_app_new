import 'package:smart_kishan/core/constants/api_endpoints.dart';
import 'package:smart_kishan/core/network/api_client.dart';
import 'package:smart_kishan/shared/models/unit.dart';

/// Fetches and caches the /units reference list. Registered as a lazy
/// singleton so the cache persists app-wide — first caller fetches, the rest
/// hit the in-memory cache. Used by inventory, sell-product, marketplace, …
class UnitRepository {
  UnitRepository({required ApiClient api}) : _api = api;

  final ApiClient _api;
  List<Unit>? _cache;

  Future<List<Unit>> getUnits({bool forceRefresh = false}) async {
    if (_cache != null && !forceRefresh) return _cache!;
    final res = await _api.get(ApiEndpoints.units);
    final list = (res.data as List)
        .map((e) => Unit.fromJson(e as Map<String, dynamic>))
        .toList();
    return _cache = list;
  }

  /// Resolve a unit by id from cache (after getUnits has run). Handy for
  /// list cards that have a unitId but no embedded unit object.
  Unit? unitById(int? id) {
    if (id == null || _cache == null) return null;
    for (final u in _cache!) {
      if (u.id == id) return u;
    }
    return null;
  }

  void clearCache() => _cache = null;
}
