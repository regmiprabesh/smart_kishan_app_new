import 'package:equatable/equatable.dart';
import '../data/market_price.dart';

sealed class MarketPriceState extends Equatable {
  const MarketPriceState();
  @override
  List<Object?> get props => [];
}

class MarketPriceLoading extends MarketPriceState {
  const MarketPriceLoading();
}

class MarketPriceLoaded extends MarketPriceState {
  const MarketPriceLoaded({required this.markets, this.query = ''});
  final List<Market> markets;
  final String query;

  MarketPriceLoaded copyWith({List<Market>? markets, String? query}) =>
      MarketPriceLoaded(
        markets: markets ?? this.markets,
        query: query ?? this.query,
      );

  @override
  List<Object?> get props => [markets, query];
}

class MarketPriceFailure extends MarketPriceState {
  const MarketPriceFailure();
}
