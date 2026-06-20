import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';

import '../data/market_price.dart';

/// Scrollable tab bar with one tab per market. Hidden by the caller when there
/// is only a single market.
class MarketTabBar extends StatelessWidget {
  const MarketTabBar({super.key, required this.markets});
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
