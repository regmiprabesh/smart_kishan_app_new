import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/utils/formatters.dart';
import '../data/market_price.dart';

/// One commodity row: name + unit on top, min/max/avg as three small labeled
/// values below. Compact, no horizontal scroll, handles long Nepali names.
class CommodityPriceRow extends StatelessWidget {
  const CommodityPriceRow({super.key, required this.commodity});
  final CommodityPrice commodity;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name + unit
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  commodity.name?.of(context) ?? '',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              if (commodity.unit?.of(context) != null &&
                  commodity.unit!.of(context).isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: colors.surfaceAlt,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    commodity.unit!.of(context),
                    style: TextStyle(fontSize: 11, color: colors.textSecondary),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          // Min / Max / Avg
          Row(
            children: [
              _Price(
                label: l10n.minPrice,
                value: commodity.min,
                color: colors.success,
              ),
              const SizedBox(width: 16),
              _Price(
                label: l10n.maxPrice,
                value: commodity.max,
                color: colors.error,
              ),
              const SizedBox(width: 16),
              _Price(
                label: l10n.avgPrice,
                value: commodity.avg,
                color: colors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Price extends StatelessWidget {
  const _Price({required this.label, required this.value, required this.color});
  final String label;
  final String? value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 10, color: colors.textHint)),
        const SizedBox(height: 2),
        Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 4),
            Text(
              context.ld(value ?? '—'),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
