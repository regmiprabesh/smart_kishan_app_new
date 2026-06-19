import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/utils/formatters.dart';

import '../data/service_center.dart';
import 'star_rating.dart';

/// Average-rating summary block (big number + stars + total count).
class ServiceCenterRatingOverview extends StatelessWidget {
  const ServiceCenterRatingOverview({super.key, required this.center});
  final ServiceCenter center;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final avg = center.averageRating ?? 0;
    final total = center.totalRatings ?? 0;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.rating.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.rating.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                context.ld(avg.toStringAsFixed(1)),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: colors.rating,
                ),
              ),
              StarRating(rating: avg.round(), size: 16),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${context.ld(total.toString())} ${total == 1 ? l10n.ratingSingular : l10n.ratingPlural}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.basedOnUserReviews,
                  style: TextStyle(fontSize: 13, color: colors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
