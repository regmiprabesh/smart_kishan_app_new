import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';

import '../cubit/market_price_cubit.dart';

/// Search field that filters commodities across the market price lists.
class MarketSearchBox extends StatelessWidget {
  const MarketSearchBox({super.key, required this.controller, required this.cubit});
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
