import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';

import '../data/service_center.dart';
import 'star_rating.dart';

/// A single review: avatar initial, reviewer name, relative time, star rating,
/// and the (optional) review text. Used in the "Recent Reviews" list.
class ReviewItem extends StatelessWidget {
  const ReviewItem({super.key, required this.rating});

  final ServiceCenterRating rating;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final name = rating.userName?.trim().isNotEmpty == true
        ? rating.userName!
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
                    if (rating.createdAt != null)
                      Text(
                        relativeTime(context, rating.createdAt!),
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.textSecondary,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                StarRating(rating: rating.rating, size: 15),
                if (rating.review?.trim().isNotEmpty == true) ...[
                  const SizedBox(height: 6),
                  Text(
                    rating.review!,
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

/// Localized "x min/hr/day(s)/week(s) ago" using the unit keys already in the
/// arb. Falls back to a date for anything older than a few weeks.
String relativeTime(BuildContext context, DateTime time) {
  final l10n = AppLocalizations.of(context)!;
  final diff = DateTime.now().difference(time);

  String n(int v) => v.toString();

  if (diff.inMinutes < 1) return '${n(1)} ${l10n.commonMinuteUnit} ${l10n.ago}';
  if (diff.inMinutes < 60) {
    return '${n(diff.inMinutes)} ${l10n.commonMinuteUnit} ${l10n.ago}';
  }
  if (diff.inHours < 24) {
    return '${n(diff.inHours)} ${l10n.commonHourUnit} ${l10n.ago}';
  }
  if (diff.inDays < 7) {
    final d = diff.inDays;
    return '${n(d)} ${d == 1 ? l10n.commonDayUnit : l10n.commonDaysUnit} ${l10n.ago}';
  }
  if (diff.inDays < 28) {
    final w = (diff.inDays / 7).floor();
    return '${n(w)} ${w == 1 ? l10n.commonWeekUnit : l10n.commonWeeksUnit} ${l10n.ago}';
  }
  return '${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')}';
}
