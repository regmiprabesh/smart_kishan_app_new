import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';

import '../review.dart';
import 'star_rating.dart';

/// A single review row: avatar initial, name, relative time, stars, optional
/// tag chips, and the optional text. Shared by the section and reviews page.
class ReviewTile extends StatelessWidget {
  const ReviewTile({super.key, required this.review});

  final Review review;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final name = review.userName?.trim().isNotEmpty == true
        ? review.userName!
        : l10n.anonymous;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: colors.primary.withValues(alpha: 0.12),
            child: Text(
              name.substring(0, 1).toUpperCase(),
              style: TextStyle(
                color: colors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                    if (review.createdAt != null)
                      Text(
                        relativeTime(context, review.createdAt!),
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.textSecondary,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                StarRating(rating: review.rating, size: 15),
                if (review.tags.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final t in review.tags)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: colors.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            t,
                            style: TextStyle(
                              fontSize: 11,
                              color: colors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
                if (review.text?.trim().isNotEmpty == true) ...[
                  const SizedBox(height: 6),
                  Text(
                    review.text!,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Localized "x min/hr/day(s)/week(s) ago", falling back to a date for older.
String relativeTime(BuildContext context, DateTime time) {
  final l10n = AppLocalizations.of(context)!;
  final diff = DateTime.now().difference(time);

  if (diff.inMinutes < 1) return '1 ${l10n.commonMinuteUnit} ${l10n.ago}';
  if (diff.inMinutes < 60) {
    return '${diff.inMinutes} ${l10n.commonMinuteUnit} ${l10n.ago}';
  }
  if (diff.inHours < 24) {
    return '${diff.inHours} ${l10n.commonHourUnit} ${l10n.ago}';
  }
  if (diff.inDays < 7) {
    final d = diff.inDays;
    return '$d ${d == 1 ? l10n.commonDayUnit : l10n.commonDaysUnit} ${l10n.ago}';
  }
  if (diff.inDays < 28) {
    final w = (diff.inDays / 7).floor();
    return '$w ${w == 1 ? l10n.commonWeekUnit : l10n.commonWeeksUnit} ${l10n.ago}';
  }
  return '${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')}';
}
