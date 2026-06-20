import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/widgets/app_bar.dart';
import 'package:smart_kishan/core/widgets/app_empty_state.dart';
import 'package:smart_kishan/core/widgets/app_search_field.dart';
import 'package:smart_kishan/features/farmer/market_price/widgets/market_price_skeleton.dart';
import '../cubit/market_price_cubit.dart';
import '../cubit/market_price_state.dart';
import '../data/market_price.dart';
import '../widgets/market_list.dart';
import '../widgets/market_tab_bar.dart';

/// Market prices: a tab per market (Kalimati, Attariya, ...), a search box that
/// filters commodities, and a compact price list per market. Backend-driven.
/// If only ONE market exists, the tab bar is hidden (just shows that market).
class MarketPriceScreen extends StatefulWidget {
  const MarketPriceScreen({super.key, required this.cubit});
  final MarketPriceCubit cubit;

  @override
  State<MarketPriceScreen> createState() => _MarketPriceScreenState();
}

class _MarketPriceScreenState extends State<MarketPriceScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider.value(
      value: widget.cubit,
      child: Scaffold(
        appBar: AppAppBar(title: l10n.marketPrices),
        body: BlocBuilder<MarketPriceCubit, MarketPriceState>(
          builder: (context, state) {
            return switch (state) {
              MarketPriceLoading() => const Center(
                child: MarketPriceSkeleton(),
              ),
              MarketPriceFailure() => AppEmptyState(
                icon: Icons.error_outline,
                title: l10n.errorGeneric,
                actionLabel: l10n.commonRefresh,
                actionIcon: Icons.refresh,
                onAction: () => widget.cubit.load(),
              ),
              MarketPriceLoaded(:final markets, :final query) =>
                markets.isEmpty
                    ? AppEmptyState(
                        icon: Icons.storefront_outlined,
                        title: l10n.marketPricesEmpty,
                      )
                    : _Body(
                        markets: markets,
                        query: query,
                        searchController: _searchController,
                        cubit: widget.cubit,
                      ),
            };
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.markets,
    required this.query,
    required this.searchController,
    required this.cubit,
  });
  final List<Market> markets;
  final String query;
  final TextEditingController searchController;
  final MarketPriceCubit cubit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final single = markets.length == 1;

    return DefaultTabController(
      length: markets.length,
      child: Column(
        children: [
          // Search box
          AppSearchField(
            hintText: l10n.marketSearchHint,
            controller: searchController,
            onChanged: cubit.search,
          ),

          // Market tabs — hidden when there's only one market.
          if (!single) MarketTabBar(markets: markets),

          // Per-market price lists
          Expanded(
            child: TabBarView(
              children: markets
                  .map((m) => MarketList(market: m, query: query, cubit: cubit))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
