import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/utils/formatters.dart';
import 'package:smart_kishan/core/utils/launcher.dart';

import '../data/service_center.dart';
import 'service_center_section_card.dart';

/// Phone / email / website / contact-person rows, each with a tap action.
class ServiceCenterContactInfo extends StatelessWidget {
  const ServiceCenterContactInfo({super.key, required this.center});
  final ServiceCenter center;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;

    final rows = <Widget>[];
    if (center.phone != null) {
      rows.add(
        _ContactRow(
          icon: Icons.phone,
          iconColor: colors.success,
          title: context.ld(center.phone!),
          subtitle: l10n.phone,
          trailing: IconButton(
            icon: Icon(Icons.call, color: colors.success, size: 22),
            onPressed: () => launchExternal('tel:${center.phone}'),
          ),
        ),
      );
    }
    if (center.email != null) {
      rows.add(
        _ContactRow(
          icon: Icons.email_outlined,
          iconColor: colors.warning,
          title: center.email!,
          subtitle: l10n.emailLabel,
          trailing: IconButton(
            icon: Icon(Icons.send_outlined, color: colors.warning),
            onPressed: () => launchExternal('mailto:${center.email}'),
          ),
        ),
      );
    }
    if (center.website != null) {
      rows.add(
        _ContactRow(
          icon: Icons.language,
          iconColor: colors.info,
          title: center.website!,
          subtitle: l10n.website,
          trailing: IconButton(
            icon: Icon(Icons.open_in_new, color: colors.info),
            onPressed: () => launchExternal(center.website!),
          ),
        ),
      );
    }
    if (center.contactPerson != null) {
      rows.add(
        _ContactRow(
          icon: Icons.person,
          iconColor: colors.primary,
          title: center.contactPerson?.of(context) ?? '',
          subtitle:
              center.contactPersonDesignation?.of(context) ??
              l10n.contactPerson,
        ),
      );
    }

    if (rows.isEmpty) return const SizedBox.shrink();

    return ServiceCenterSectionCard(
      title: l10n.contactInformation,
      padding: EdgeInsets.zero,
      child: Column(children: rows),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: colors.textPrimary,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: colors.textSecondary, fontSize: 12),
      ),
      trailing: trailing,
    );
  }
}
