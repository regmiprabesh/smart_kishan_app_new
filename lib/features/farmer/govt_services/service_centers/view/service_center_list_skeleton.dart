import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/widgets/app_shimmer.dart';

/// Loading placeholder for the service-center list. Mirrors the real
/// [ServiceCenterCard]: a tinted header strip (icon + name + featured pill),
/// then body with address, distance/rating pills, phone/email rows, and the
/// two action buttons.
class ServiceCenterListSkeleton extends StatelessWidget {
  const ServiceCenterListSkeleton({super.key, this.count = 5});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: context.colors.surface,
          child: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: AppShimmer(child: _Box(double.infinity, 48, radius: 12)),
              ),
              // Category chips row
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 5,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (_, i) => Padding(
                      padding: EdgeInsetsGeometry.only(left: 16),
                      child: AppShimmer(
                        // Vary widths a little so it reads as chips, not bars.
                        child: _Box(
                          i == 0 ? 64 : (i.isEven ? 110 : 92),
                          38,
                          radius: 10,
                        ),
                      ),
                    ),
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
        border: Border.all(color: colors.border.withValues(alpha: 0.5)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header strip: type icon + name + featured pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            color: colors.primary.withValues(alpha: 0.06),
            child: Row(
              children: [
                const AppShimmer(child: _Box(38, 38, radius: 10)),
                const SizedBox(width: 12),
                Expanded(child: AppShimmer(child: _Box(double.infinity, 15))),
                const SizedBox(width: 12),
                const AppShimmer(child: _Box(64, 22, radius: 12)),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Address (two lines)
                const AppShimmer(child: _Box(double.infinity, 12)),
                const SizedBox(height: 6),
                AppShimmer(
                  child: _Box(MediaQuery.sizeOf(context).width * 0.5, 12),
                ),
                const SizedBox(height: 12),

                // Distance + rating pills
                Row(
                  children: const [
                    AppShimmer(child: _Box(78, 26, radius: 8)),
                    SizedBox(width: 8),
                    AppShimmer(child: _Box(64, 26, radius: 8)),
                  ],
                ),
                const SizedBox(height: 12),

                // Phone + email rows
                Row(
                  children: const [
                    AppShimmer(child: _Box(16, 16, radius: 4)),
                    SizedBox(width: 8),
                    AppShimmer(child: _Box(120, 12)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: const [
                    AppShimmer(child: _Box(16, 16, radius: 4)),
                    SizedBox(width: 8),
                    AppShimmer(child: _Box(160, 12)),
                  ],
                ),
                const SizedBox(height: 16),

                // Two action buttons
                Row(
                  children: const [
                    Expanded(
                      child: AppShimmer(
                        child: _Box(double.infinity, 44, radius: 10),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: AppShimmer(
                        child: _Box(double.infinity, 44, radius: 10),
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

/// A plain rounded white box for AppShimmer to animate over.
class _Box extends StatelessWidget {
  const _Box(this.width, this.height, {this.radius = 6});
  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
