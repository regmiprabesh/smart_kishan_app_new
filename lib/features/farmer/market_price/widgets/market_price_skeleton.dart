import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/widgets/app_shimmer.dart';

/// Shimmer shown while market prices load — mirrors the search + tab + list layout.
class MarketPriceSkeleton extends StatelessWidget {
  const MarketPriceSkeleton({super.key, this.rowCount = 10});
  final int rowCount;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search box strip
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: AppShimmer(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        // Tab bar strip
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              AppShimmer.box(width: 90, height: 32),
              const SizedBox(width: 12),
              AppShimmer.box(width: 72, height: 32),
              const SizedBox(width: 12),
              AppShimmer.box(width: 80, height: 32),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Date chip
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: AppShimmer.box(width: 160, height: 14),
        ),
        // Price rows
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: rowCount,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              thickness: 1,
              indent: 16,
              endIndent: 16,
              color: colors.divider,
            ),
            itemBuilder: (_, __) => const _SkeletonRow(),
          ),
        ),
      ],
    );
  }
}

class _SkeletonRow extends StatelessWidget {
  const _SkeletonRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name + unit chip
          Row(
            children: [
              AppShimmer.box(width: 130, height: 14),
              const Spacer(),
              AppShimmer.box(width: 44, height: 24),
            ],
          ),
          const SizedBox(height: 10),
          // Min / Max / Avg value pills
          Row(
            children: [
              AppShimmer.box(width: 56, height: 28),
              const SizedBox(width: 16),
              AppShimmer.box(width: 56, height: 28),
              const SizedBox(width: 16),
              AppShimmer.box(width: 56, height: 28),
            ],
          ),
        ],
      ),
    );
  }
}
