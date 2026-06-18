import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/widgets/app_shimmer.dart';

/// Shimmer grid shown while crops load — mirrors the 3-column tile layout.
class CropGridSkeleton extends StatelessWidget {
  const CropGridSkeleton({super.key, this.count = 9});
  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: count,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.82,
      ),
      itemBuilder: (_, __) => Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.border.withValues(alpha: 0.5)),
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: AppShimmer(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: AppShimmer.box(width: 50, height: 10),
            ),
          ],
        ),
      ),
    );
  }
}
