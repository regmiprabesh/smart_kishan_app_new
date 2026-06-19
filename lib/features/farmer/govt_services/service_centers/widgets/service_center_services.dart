import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';

import '../data/service_center.dart';
import 'service_center_section_card.dart';

/// "Services offered" as wrapped pill chips.
class ServiceCenterServices extends StatelessWidget {
  const ServiceCenterServices({super.key, required this.center});
  final ServiceCenter center;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    return ServiceCenterSectionCard(
      title: l10n.servicesOffered,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: center.services!.map((s) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              s?.of(context) ?? '',
              style: TextStyle(
                fontSize: 13,
                color: colors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
