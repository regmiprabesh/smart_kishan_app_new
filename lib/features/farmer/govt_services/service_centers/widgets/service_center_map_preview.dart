import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/utils/formatters.dart';
import 'package:smart_kishan/core/widgets/app_primary_button.dart';

import '../data/service_center.dart';
import 'service_center_type_style.dart';
import 'star_rating.dart';

/// The card shown when a map marker is tapped (image 4): type icon, name,
/// address, "X.X km away", a route-status pill, a close (×) button, the rating,
/// and a "View details" button. Mirrors the original map preview card.
class ServiceCenterMapPreview extends StatelessWidget {
  const ServiceCenterMapPreview({
    super.key,
    required this.center,
    required this.routeLoading,
    required this.hasRoute,
    required this.onClose,
    required this.onOpenDetail,
  });

  final ServiceCenter center;
  final bool routeLoading;
  final bool hasRoute;
  final VoidCallback onClose;
  final VoidCallback onOpenDetail;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final typeColor = ServiceCenterTypeStyle.of(center.type);
    final detailsButton = FilledButton.icon(
      onPressed: onOpenDetail,
      icon: const Icon(Icons.info_outline, size: 20),
      label: Text(
        l10n.viewDetails,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );

    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(18),
      color: colors.surface,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top: icon + name/address/distance + close.
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    ServiceCenterTypeStyle.iconOf(center.type),
                    color: typeColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        center.name?.of(context) ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        center.address?.of(context) ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: colors.textSecondary,
                        ),
                      ),
                      if (center.distance != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.navigation,
                              size: 13,
                              color: colors.info,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${context.ld(center.distance!.toStringAsFixed(1))} ${l10n.km} ${l10n.away}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: colors.info,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                InkWell(
                  onTap: onClose,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: colors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Route-status pill: loading → loaded • X.X km.
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: colors.info.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  if (routeLoading)
                    SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colors.info,
                      ),
                    )
                  else
                    Icon(Icons.turn_right, size: 16, color: colors.info),
                  const SizedBox(width: 8),
                  Text(
                    routeLoading
                        ? l10n.loadingRoute
                        : hasRoute
                        ? '${l10n.routeLoaded} • ${context.ld(center.distance?.toStringAsFixed(1) ?? '')} ${l10n.km}'
                        : l10n.routeUnavailable,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: colors.info,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Bottom: rating + details button.
            if (center.hasRatings)
              Row(
                children: [
                  StarRating(rating: center.averageRating!.round(), size: 16),
                  const SizedBox(width: 6),
                  Text(
                    '${context.ld(center.averageRating!.toStringAsFixed(1))} (${context.ld(center.totalRatings.toString())})',
                    style: TextStyle(fontSize: 13, color: colors.rating),
                  ),
                  const Spacer(),
                  detailsButton,
                ],
              )
            else
              SizedBox(width: double.infinity, child: detailsButton),
          ],
        ),
      ),
    );
  }
}
