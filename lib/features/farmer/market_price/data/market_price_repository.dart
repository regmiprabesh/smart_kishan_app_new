import 'package:smart_kishan/core/constants/api_endpoints.dart';
import 'package:smart_kishan/core/network/api_client.dart';
import 'market_price.dart';

/// Fetches aggregated market prices from our backend (which normalizes the
/// external sources). The app never calls Kalimati/municipality APIs directly.
class MarketPriceRepository {
  MarketPriceRepository({required ApiClient api}) : _api = api;
  final ApiClient _api;

  Future<List<Market>> fetchMarkets() async {
    final res = await _api.get(ApiEndpoints.marketPrices);
    final list = (res.data as List?) ?? const [];
    return list.map((e) => Market.fromJson(e as Map<String, dynamic>)).toList();
  }
}
