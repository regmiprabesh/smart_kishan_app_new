import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/widgets/app_section_header.dart';
import 'widgets/govt_service_card.dart';

class GovtServicesSection extends StatelessWidget {
  const GovtServicesSection({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final grad = context.colors.govServiceGradients;

    final cards = <GovServiceCardData>[
      GovServiceCardData(
        title: l10n.homeServiceCentersTitle,
        subtitle: l10n.homeServiceCentersSubtitle,
        badge: l10n.homeServiceCentersBadge,
        icon: Icons.location_city,
        gradient: grad[0],
        onTap: () => context.push(AppRoutePath.serviceCenters),
      ),
      GovServiceCardData(
        title: l10n.homeSubsidiesTitle,
        subtitle: l10n.homeSubsidiesSubtitle,
        badge: l10n.homeSubsidiesBadge,
        icon: Icons.account_balance_wallet,
        gradient: grad[1],
        onTap: () => context.push(AppRoutePath.subsidies),
      ),
      // …Complaints, Surveys
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(title: l10n.governmentServices),
        const SizedBox(height: 12),
        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            itemCount: cards.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final c = cards[i];
              return GovtServiceCard(
                title: c.title,
                subtitle: c.subtitle,
                badge: c.badge,
                icon: c.icon,
                gradientColors: c.gradient,
                onTap: c.onTap,
              );
            },
          ),
        ),
      ],
    );
  }
}

class GovServiceCardData {
  const GovServiceCardData({
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String badge;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onTap;
}
