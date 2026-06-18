import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/utils/formatters.dart';
import 'package:smart_kishan/core/widgets/app_empty_state.dart';

import '../data/service_center.dart';
import 'service_center_type_style.dart';

/// Draggable sheet shown over the map when nothing is selected — lists the
/// nearby centers (already ordered + filtered by the cubit's query). Mirrors
/// the original "नजिकका सेवा केन्द्रहरू" sheet. Tapping a row selects it on the
/// map (which swaps this sheet for the route preview card).
class ServiceCenterNearbySheet extends StatelessWidget {
  const ServiceCenterNearbySheet({
    super.key,
    required this.centers,
    required this.title,
    required this.onTapCenter,
    required this.onOpenDetail,
    this.maxItems = 5,
  });

  final List<ServiceCenter> centers;
  final String title;
  final void Function(ServiceCenter) onTapCenter;
  final void Function(ServiceCenter) onOpenDetail;
  final int maxItems;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final shown = centers.take(maxItems).toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.70,
      minChildSize: 0.11,
      maxChildSize: 0.70,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 12,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.zero,
            children: [
              // Grab handle
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 6),
                child: Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                child: Row(
                  children: [
                    Icon(Icons.near_me, size: 18, color: colors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: colors.textSecondary,
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: colors.divider),
              // Items (no own controller, no own scroll — part of the outer list)
              if (shown.isEmpty)
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.sizeOf(context).height * 0.40,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: AppEmptyState(
                        icon: Icons.location_off,
                        title: l10n.noServiceCentersFound,
                        compact: true,
                        description: l10n.tryAdjustingFilters,
                      ),
                    ),
                  ),
                )
              else
                ...List.generate(shown.length, (i) {
                  return Column(
                    children: [
                      _NearbyRow(
                        index: i + 1,
                        center: shown[i],
                        highlightFirst: i == 0,
                        onTap: () => onTapCenter(shown[i]),
                      ),
                      if (i != shown.length - 1)
                        Divider(height: 1, color: colors.divider, indent: 76),
                    ],
                  );
                }),
            ],
          ),
        );
      },
    );
  }
}

class _NearbyRow extends StatelessWidget {
  const _NearbyRow({
    required this.index,
    required this.center,
    required this.highlightFirst,
    required this.onTap,
  });

  final int index;
  final ServiceCenter center;
  final bool highlightFirst;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final typeColor = ServiceCenterTypeStyle.of(center.type);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: typeColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                ServiceCenterTypeStyle.iconOf(center.type),
                color: typeColor,
                size: 20,
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
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      if (center.distance != null) ...[
                        Icon(Icons.navigation, size: 12, color: colors.info),
                        const SizedBox(width: 3),
                        Text(
                          '${context.ld(center.distance!.toStringAsFixed(1))} ${l10n.km}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: colors.info,
                          ),
                        ),
                      ],
                      if (center.hasRatings) ...[
                        const SizedBox(width: 10),
                        Icon(Icons.star, size: 13, color: colors.rating),
                        const SizedBox(width: 2),
                        Text(
                          context.ld(center.averageRating!.toStringAsFixed(1)),
                          style: TextStyle(fontSize: 12, color: colors.rating),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: colors.iconSecondary),
          ],
        ),
      ),
    );
  }
}
