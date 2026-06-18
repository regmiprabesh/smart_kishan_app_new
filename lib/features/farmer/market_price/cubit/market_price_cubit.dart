import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/market_price.dart';
import '../data/market_price_repository.dart';
import 'market_price_state.dart';

/// Loads markets from the backend and holds a search query. The search filters
/// commodities by name (en or ne) — applied per-market at display time.
class MarketPriceCubit extends Cubit<MarketPriceState> {
  MarketPriceCubit(this._repository) : super(const MarketPriceLoading());

  final MarketPriceRepository _repository;

  Future<void> load() async {
    emit(const MarketPriceLoading());
    try {
      final markets = await _repository.fetchMarkets();
      emit(MarketPriceLoaded(markets: markets));
    } catch (e) {
      debugPrint('Market prices load failed: $e');
      emit(const MarketPriceFailure());
    }
  }

  void search(String query) {
    final s = state;
    if (s is MarketPriceLoaded) emit(s.copyWith(query: query));
  }

  /// Commodities for a market, filtered by the current query (matches en/ne
  /// commodity name, case-insensitive).
  List<CommodityPrice> filtered(Market market, String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return market.commodities;
    return market.commodities.where((c) {
      final en = (c.name?.en ?? '').toLowerCase();
      final ne = (c.name?.ne ?? '').toLowerCase();
      return en.contains(q) || ne.contains(q);
    }).toList();
  }
}
