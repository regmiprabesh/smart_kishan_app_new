import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/widgets/app_shimmer.dart';

/// Loading placeholder mirroring the subsidy card: colored header band +
/// chip row + description lines + an actions row.
class SubsidyListSkeleton extends StatelessWidget {
  const SubsidyListSkeleton({super.key, this.count = 4});
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
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: colors.surfaceAlt,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppShimmer.box(width: 180, height: 16, radius: 6),
                const SizedBox(height: 8),
                AppShimmer.box(width: 90, height: 12, radius: 6),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppShimmer.box(width: 110, height: 28, radius: 8),
                    AppShimmer.box(width: 70, height: 28, radius: 8),
                  ],
                ),
                const SizedBox(height: 14),
                AppShimmer.box(height: 12, radius: 6),
                const SizedBox(height: 8),
                AppShimmer.box(width: 220, height: 12, radius: 6),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: AppShimmer.box(height: 38, radius: 8)),
                    const SizedBox(width: 8),
                    AppShimmer.box(width: 90, height: 38, radius: 8),
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
