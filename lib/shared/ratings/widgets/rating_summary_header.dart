import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/utils/formatters.dart';

import 'star_rating.dart';

/// The aggregate header: big average, stars, and the rating count. Shared by
/// the inline section and the reviews page.
class RatingSummaryHeader extends StatelessWidget {
  const RatingSummaryHeader({
    super.key,
    required this.average,
    required this.total,
  });

  final double average;
  final int total;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final hasRatings = total > 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.rating.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            context.ld(average.toStringAsFixed(1)),
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StarRating(rating: average.round(), size: 18),
              const SizedBox(height: 4),
              Text(
                hasRatings
                    ? '${context.ld(total.toString())} ${total == 1 ? l10n.ratingSingular : l10n.ratingPlural}'
                    : l10n.subsidyNoRatingsYet,
                style: TextStyle(fontSize: 13, color: colors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
