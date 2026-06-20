import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/widgets/app_shimmer.dart';

/// Loading placeholder for [WeatherCard] — mirrors the loaded layout (date,
/// big temperature, humidity line on the left; condition icon + label on the
/// right; and the pesticide-recommendation banner) so the header doesn't jump
/// when the real data arrives.
class WeatherCardSkeleton extends StatelessWidget {
  const WeatherCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colors.shadow,
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left: date, temperature, humidity
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppShimmer.box(width: 130, height: 13, radius: 6),
                    const SizedBox(height: 10),
                    AppShimmer.box(width: 96, height: 40, radius: 10),
                    const SizedBox(height: 10),
                    AppShimmer.box(width: 110, height: 13, radius: 6),
                  ],
                ),
                // Right: condition icon + label
                Column(
                  children: [
                    AppShimmer.box(width: 72, height: 72, radius: 16),
                    const SizedBox(height: 6),
                    AppShimmer.box(width: 56, height: 13, radius: 6),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(color: colors.divider),
            const SizedBox(height: 8),
            // Recommendation banner
            AppShimmer.box(width: double.infinity, height: 42, radius: 10),
          ],
        ),
      ),
    );
  }
}
