import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/widgets/app_shimmer.dart';

/// Shimmer placeholder list mirroring the new [ServiceCenterCard] (header strip
/// + body with address, pills, phone/email, and two action buttons).
class ServiceCenterListSkeleton extends StatelessWidget {
  const ServiceCenterListSkeleton({super.key, this.count = 4});

  final int count;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: count,
      separatorBuilder: (_, _) => const SizedBox(height: 14),
      itemBuilder: (_, _) => const _SkeletonCard(),
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header strip
          Container(
            color: colors.primary.withValues(alpha: 0.08),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: const [
                AppShimmer(child: SizedBox(width: 44, height: 44)),
                SizedBox(width: 12),
                Expanded(child: AppShimmer(child: SizedBox(height: 16))),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                AppShimmer(child: SizedBox(width: 200, height: 13)),
                SizedBox(height: 12),
                Row(
                  children: [
                    AppShimmer(child: SizedBox(width: 70, height: 24)),
                    SizedBox(width: 8),
                    AppShimmer(child: SizedBox(width: 70, height: 24)),
                  ],
                ),
                SizedBox(height: 12),
                AppShimmer(child: SizedBox(width: 150, height: 13)),
                SizedBox(height: 8),
                AppShimmer(child: SizedBox(width: 180, height: 13)),
                SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(child: AppShimmer(child: SizedBox(height: 40))),
                    SizedBox(width: 12),
                    Expanded(child: AppShimmer(child: SizedBox(height: 40))),
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
