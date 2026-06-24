import 'package:smart_kishan/core/constants/api_endpoints.dart';
import 'package:smart_kishan/core/network/api_client.dart';

import 'rating_tag.dart';

/// Loads the keyed rating-tag catalog once and caches it. Tags are stored as
/// language-independent keys; this resolves keys → localized labels for both
/// the rate page (per-context options) and review display.
///
/// Registered as a lazy singleton and warmed at startup. If the fetch fails the
/// catalog stays empty and callers fall back to a prettified key, so missing
/// labels never block rating or break review rendering.
class RatingTagCatalog {
  RatingTagCatalog(this._api);

  final ApiClient _api;

  final Map<String, List<RatingTag>> _byContext = {};
  final Map<String, RatingTag> _byKey = {};
  bool _loaded = false;
  Future<void>? _inflight;

  bool get isLoaded => _loaded;

  /// Fetches the catalog once. Safe to call repeatedly / concurrently.
  Future<void> ensureLoaded() {
    if (_loaded) return Future.value();
    return _inflight ??= _load();
  }

  Future<void> _load() async {
    try {
      final res = await _api.get(ApiEndpoints.ratingTags);
      final data = res.data;
      if (data is Map) {
        data.forEach((context, list) {
          if (list is List) {
            final tags = list
                .whereType<Map>()
                .map((m) => RatingTag.fromJson(Map<String, dynamic>.from(m)))
                .toList();
            _byContext['$context'] = tags;
            for (final t in tags) {
              _byKey[t.key] = t;
            }
          }
        });
      }
      _loaded = true;
    } catch (_) {
      // Leave unloaded; callers fall back to prettified keys.
    } finally {
      _inflight = null;
    }
  }

  /// Selectable options for a context ('subsidy', 'service_center'), or empty.
  List<RatingTag> forContext(String? context) =>
      context == null ? const [] : (_byContext[context] ?? const []);

  /// Localized label for a stored key, falling back to a prettified key
  /// (e.g. 'fast_approval' → 'Fast approval') when the catalog lacks it.
  String labelFor(String key, String languageCode) {
    final tag = _byKey[key];
    if (tag != null) return tag.label(languageCode);
    final pretty = key.replaceAll('_', ' ').trim();
    if (pretty.isEmpty) return key;
    return pretty[0].toUpperCase() + pretty.substring(1);
  }
}
