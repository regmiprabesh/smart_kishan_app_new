import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/utils/formatters.dart';

import '../data/service_center.dart';
import 'service_center_section_card.dart';

/// Quiet key facts grouped into ONE card (distance / ward / hours) instead of
/// several thin cards — calmer rhythm.
class ServiceCenterInfoCard extends StatelessWidget {
  const ServiceCenterInfoCard({super.key, required this.center});
  final ServiceCenter center;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;

    final rows = <Widget>[];
    if (center.distance != null) {
      rows.add(
        _InfoRow(
          icon: Icons.navigation,
          iconColor: colors.info,
          label: l10n.distance,
          value:
              '${context.ld(center.distance!.toStringAsFixed(1))} ${l10n.km} ${l10n.away}',
        ),
      );
    }
    if (center.wardNo != null) {
      rows.add(
        _InfoRow(
          icon: Icons.tag,
          iconColor: colors.textSecondary,
          label: l10n.wardNo(context.ld(center.wardNo.toString())),
          value: '',
        ),
      );
    }
    if (center.operatingHours != null && center.operatingHours!.isNotEmpty) {
      rows.add(_HoursBlock(center: center));
    }

    if (rows.isEmpty) return const SizedBox.shrink();

    return ServiceCenterSectionCard(
      title: l10n.basicInformation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            rows[i],
            if (i != rows.length - 1) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: colors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        if (value.isNotEmpty)
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: iconColor == colors.textSecondary
                  ? colors.textSecondary
                  : iconColor,
            ),
          ),
      ],
    );
  }
}

class _HoursBlock extends StatelessWidget {
  const _HoursBlock({required this.center});
  final ServiceCenter center;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final entries = center.operatingHours!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.schedule, size: 18, color: colors.textSecondary),
            const SizedBox(width: 10),
            Text(
              l10n.operatingHours,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...entries.map(
          (e) => Padding(
            padding: const EdgeInsets.only(left: 28, bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  e.label.of(context),
                  style: TextStyle(fontSize: 13, color: colors.textSecondary),
                ),
                Text(
                  e.hours.of(context),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: e.closed ? FontWeight.w600 : FontWeight.w400,
                    color: e.closed ? colors.error : colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
