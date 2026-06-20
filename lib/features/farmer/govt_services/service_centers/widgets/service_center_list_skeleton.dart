import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/widgets/app_search_field.dart';
import 'package:smart_kishan/core/widgets/app_shimmer.dart';

/// Loading placeholder for the service-center list. Mirrors the rendered screen
/// so the transition is seamless: a disabled (static) search bar, a row of
/// shimmering category chips, then cards whose shape matches [ServiceCenterCard]
/// — header strip (icon + name) and a body with address, distance/rating pills,
/// phone/email rows, and the two action buttons.
class ServiceCenterListSkeleton extends StatelessWidget {
  const ServiceCenterListSkeleton({super.key, this.count = 5});
  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        // Same chrome as the loaded screen: static search bar + chips row.
        ColoredBox(
          color: colors.surface,
          child: Column(
            children: [
              AppSearchField(
                hintText: l10n.searchServiceCentersHint,
                enabled: false,
              ),
              SizedBox(
                height: 55,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  itemCount: 5,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (_, i) => AppShimmer.box(
                    // Vary widths so it reads as chips, not bars.
                    width: i == 0 ? 64 : (i.isEven ? 104 : 88),
                    height: 38,
                    radius: 8,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: count,
            separatorBuilder: (_, _) => const SizedBox(height: 14),
            itemBuilder: (_, _) => const _SkeletonCard(),
          ),
        ),
      ],
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
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
          // Header strip — same green tint as the real card.
          Container(
            color: colors.primary.withValues(alpha: 0.10),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                AppShimmer.box(width: 32, height: 32, radius: 12),
                const SizedBox(width: 12),
                AppShimmer.box(width: 150, height: 15, radius: 6),
              ],
            ),
          ),
          // Body
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _Line(icon: Icons.location_on), // address (full width)
                const SizedBox(height: 10),
                Row(
                  children: [
                    AppShimmer.box(width: 78, height: 26, radius: 8),
                    const SizedBox(width: 8),
                    AppShimmer.box(width: 88, height: 26, radius: 8),
                  ],
                ),
                const SizedBox(height: 12),
                const _Line(icon: Icons.phone, width: 140),
                const SizedBox(height: 8),
                const _Line(icon: Icons.email_outlined, width: 190),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(child: AppShimmer.box(height: 35, radius: 10)),
                    const SizedBox(width: 12),
                    Expanded(child: AppShimmer.box(height: 35, radius: 10)),
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

/// An icon + a shimmering text line, matching the card's icon rows.
class _Line extends StatelessWidget {
  const _Line({required this.icon, this.width});
  final IconData icon;

  /// Fixed line width; null fills the remaining space (e.g. the address row).
  final double? width;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Icon(
          icon,
          size: 17,
          color: colors.iconSecondary.withValues(alpha: 0.5),
        ),
        const SizedBox(width: 8),
        if (width == null)
          Expanded(child: AppShimmer.box(height: 12, radius: 6))
        else
          AppShimmer.box(width: width, height: 12, radius: 6),
      ],
    );
  }
}
