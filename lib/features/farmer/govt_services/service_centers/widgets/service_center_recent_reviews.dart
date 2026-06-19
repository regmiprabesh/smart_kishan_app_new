import 'package:flutter/material.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';

import '../data/service_center.dart';
import 'review_item.dart';
import 'service_center_section_card.dart';

/// Up to five most-recent reviews, divided.
class ServiceCenterRecentReviews extends StatelessWidget {
  const ServiceCenterRecentReviews({super.key, required this.center});
  final ServiceCenter center;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final reviews = center.ratings!;
    final shown = reviews.take(5).toList();

    return ServiceCenterSectionCard(
      title: l10n.recentReviews,
      child: Column(
        children: [
          for (var i = 0; i < shown.length; i++) ...[
            ReviewItem(rating: shown[i]),
            if (i != shown.length - 1) const Divider(height: 1),
          ],
        ],
      ),
    );
  }
}
