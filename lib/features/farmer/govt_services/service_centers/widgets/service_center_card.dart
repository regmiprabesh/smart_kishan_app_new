import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/utils/formatters.dart';
import 'package:smart_kishan/core/widgets/app_outlined_button.dart';
import 'package:smart_kishan/core/widgets/app_primary_button.dart';

import '../data/service_center.dart';
import 'service_center_type_style.dart';

/// Service-center list card (matches the original): a light-green header strip
/// with the type icon, name, and a "Featured" pill; then a body with the
/// address, distance + rating pills, phone and email rows, and two actions —
/// "View on map" and "Details".
class ServiceCenterCard extends StatelessWidget {
  const ServiceCenterCard({
    super.key,
    required this.center,
    required this.onViewOnMap,
    required this.onViewDetail,
  });

  final ServiceCenter center;
  final VoidCallback onViewOnMap;
  final VoidCallback onViewDetail;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final typeColor = ServiceCenterTypeStyle.of(center.type);

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header strip: light green tint ──────────────────────────────
          Container(
            color: colors.primary.withValues(alpha: 0.10),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    ServiceCenterTypeStyle.iconOf(center.type),
                    color: typeColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    center.name?.of(context) ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                if (center.isFeatured) ...[
                  const SizedBox(width: 8),
                  _FeaturedPill(label: l10n.featured),
                ],
              ],
            ),
          ),

          // ── Body ─────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Address
                _IconLine(
                  icon: Icons.location_on,
                  child: Text(
                    center.address?.of(context) ?? '',
                    style: TextStyle(fontSize: 14, color: colors.textSecondary),
                  ),
                ),
                const SizedBox(height: 10),

                // Distance + rating pills
                Row(
                  children: [
                    if (center.distance != null) ...[
                      _Pill(
                        icon: Icons.navigation,
                        color: colors.info,
                        text:
                            '${context.ld(center.distance!.toStringAsFixed(1))} ${l10n.km}',
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (center.hasRatings)
                      _Pill(
                        icon: Icons.star,
                        color: colors.rating,
                        text:
                            '${context.ld(center.averageRating!.toStringAsFixed(1))} (${context.ld(center.totalRatings.toString())})',
                      ),
                  ],
                ),

                // Phone
                if (center.phone != null && center.phone!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _IconLine(
                    icon: Icons.phone,
                    child: Text(
                      context.ld(center.phone!),
                      style: TextStyle(
                        fontSize: 14,
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                ],

                // Email
                if (center.email != null && center.email!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _IconLine(
                    icon: Icons.email_outlined,
                    child: Text(
                      center.email!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 14),

                // Actions: View on map (outlined) + Details (filled)
                Row(
                  children: [
                    Expanded(
                      child: AppOutlinedButton(
                        label: l10n.viewOnMap,
                        onPressed: onViewOnMap,
                        height: 35,
                        icon: Icons.map,
                        fontSize: 13,
                        iconSize: 14,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppPrimaryButton(
                        label: l10n.details,
                        onPressed: onViewDetail,
                        height: 35,
                        icon: Icons.info_outline_rounded,
                        fontSize: 13,
                        iconSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IconLine extends StatelessWidget {
  const _IconLine({required this.icon, required this.child});
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 17, color: colors.iconSecondary),
        const SizedBox(width: 8),
        Expanded(child: child),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.color, required this.text});
  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedPill extends StatelessWidget {
  const _FeaturedPill({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: colors.rating,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, size: 12, color: Colors.white),
          const SizedBox(width: 3),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
