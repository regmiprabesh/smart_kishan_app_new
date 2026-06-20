import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/utils/formatters.dart';
import 'package:smart_kishan/core/widgets/app_empty_state.dart';

import '../cubit/market_price_cubit.dart';
import '../data/market_price.dart';
import 'commodity_price_row.dart';

/// The price list for a single market: a last-updated date header and the
/// filtered commodity rows (or an empty state when the search matches nothing).
class MarketList extends StatelessWidget {
  const MarketList({
    super.key,
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
                  separatorBuilder: (_, _) => Divider(
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
