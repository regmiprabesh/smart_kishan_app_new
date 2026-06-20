import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/widgets/app_shimmer.dart';

/// Loading placeholder for the shared "icon-chip card" list pattern used by the
/// daily-activity and inventory lists: a leading icon chip, a title + subtitle,
/// a trailing ⋮ menu, and two description lines.
class AppCardListSkeleton extends StatelessWidget {
  const AppCardListSkeleton({super.key, this.count = 5});
  final int count;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: count,
      itemBuilder: (_, _) => const _CardSkeleton(),
    );
  }
}

class _CardSkeleton extends StatelessWidget {
  const _CardSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Leading icon chip
                AppShimmer.box(width: 42, height: 42, radius: 12),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppShimmer.box(width: 150, height: 15, radius: 6),
                      const SizedBox(height: 8),
                      AppShimmer.box(width: 100, height: 12, radius: 6),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Trailing ⋮ menu
                AppShimmer.box(width: 24, height: 24, radius: 6),
              ],
            ),
            const SizedBox(height: 14),
            // Description lines
            AppShimmer.box(height: 11, radius: 6),
            const SizedBox(height: 8),
            AppShimmer.box(width: 200, height: 11, radius: 6),
          ],
        ),
      ),
    );
  }
}
