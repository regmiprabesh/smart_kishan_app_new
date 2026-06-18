import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/utils/formatters.dart';
import 'package:smart_kishan/core/widgets/app_bar.dart';
import 'package:smart_kishan/core/widgets/app_empty_state.dart';
import 'package:smart_kishan/features/farmer/market_price/widgets/market_price_skeleton.dart';
import '../cubit/market_price_cubit.dart';
import '../cubit/market_price_state.dart';
import '../data/market_price.dart';
import '../widgets/commodity_price_row.dart';

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
    final single = markets.length == 1;

    return DefaultTabController(
      length: markets.length,
      child: Column(
        children: [
          // Search box
          _SearchBox(controller: searchController, cubit: cubit),

          // Market tabs — hidden when there's only one market.
          if (!single) _MarketTabBar(markets: markets),

          // Per-market price lists
          Expanded(
            child: TabBarView(
              children: markets
                  .map(
                    (m) => _MarketList(market: m, query: query, cubit: cubit),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBox extends StatelessWidget {
  const _SearchBox({required this.controller, required this.cubit});
  final TextEditingController controller;
  final MarketPriceCubit cubit;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: TextField(
        controller: controller,
        onChanged: cubit.search,
        decoration: InputDecoration(
          hintText: l10n.marketSearchHint,
          prefixIcon: Icon(Icons.search, color: colors.iconSecondary),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.close, color: colors.iconSecondary),
                  onPressed: () {
                    controller.clear();
                    cubit.search('');
                  },
                )
              : null,
          filled: true,
          fillColor: colors.surfaceAlt,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _MarketTabBar extends StatelessWidget {
  const _MarketTabBar({required this.markets});
  final List<Market> markets;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return TabBar(
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      labelColor: colors.primary,
      unselectedLabelColor: colors.textSecondary,
      indicatorColor: colors.primary,
      indicatorWeight: 2.5,
      labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      tabs: markets
          .map((m) => Tab(text: m.name?.of(context) ?? m.key))
          .toList(),
    );
  }
}

class _MarketList extends StatelessWidget {
  const _MarketList({
    required this.market,
    required this.query,
    required this.cubit,
  });
  final Market market;
  final String query;
  final MarketPriceCubit cubit;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context)!;
    final items = cubit.filtered(market, query);

    return Column(
      children: [
        // Last-updated date
        if (market.date != null && market.date!.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 14,
                  color: colors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  '${l10n.marketLastUpdated}: ${context.shortDate(market.date!)}',
                  style: TextStyle(fontSize: 12, color: colors.textSecondary),
                ),
              ],
            ),
          ),

        Expanded(
          child: items.isEmpty
              ? AppEmptyState(
                  icon: Icons.search_off,
                  title: l10n.marketNoResults,
                  compact: true,
                )
              : ListView.separated(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                    color: colors.divider,
                  ),
                  itemBuilder: (_, i) => CommodityPriceRow(commodity: items[i]),
                ),
        ),
      ],
    );
  }
}
