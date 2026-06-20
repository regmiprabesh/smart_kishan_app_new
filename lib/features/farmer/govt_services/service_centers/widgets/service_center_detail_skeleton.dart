import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/widgets/app_shimmer.dart';

/// Loading placeholder for the service-center detail screen. Mirrors the real
/// layout: hero banner, info card, rating overview, contact card, directions
/// button, and the your-rating card.
class ServiceCenterDetailSkeleton extends StatelessWidget {
  const ServiceCenterDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        // Hero banner
        AppShimmer(child: _Box(double.infinity, 210)),

        // Info card
        _CardBlock(
          children: [
            _Box(140, 16), // title
            SizedBox(height: 14),
            _LabelValueRow(),
            SizedBox(height: 12),
            _LabelValueRow(),
          ],
        ),

        // Rating overview
        _CardBlock(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Box(56, 34), // big number
                    SizedBox(height: 6),
                    _Box(90, 16), // stars
                  ],
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Box(120, 14),
                      SizedBox(height: 6),
                      _Box(160, 12),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),

        // Contact card (title + 3 rows)
        _CardBlock(
          children: [
            _Box(150, 16),
            SizedBox(height: 16),
            _ContactRowSkeleton(),
            SizedBox(height: 16),
            _ContactRowSkeleton(),
            SizedBox(height: 16),
            _ContactRowSkeleton(),
          ],
        ),

        // Directions button
        Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: AppShimmer(child: _Box(double.infinity, 46, radius: 10)),
        ),

        // Your-rating card
        _CardBlock(
          children: [
            _Box(110, 16),
            SizedBox(height: 14),
            _Box(double.infinity, 12),
            SizedBox(height: 12),
            _Box(double.infinity, 46, radius: 10),
          ],
        ),
      ],
    );
  }
}

/// A bordered card wrapper that shimmers its children (matches `_Card`).
class _CardBlock extends StatelessWidget {
  const _CardBlock({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final c in children)
            c is _Box ? AppShimmer(child: c) : _wrapShimmer(c),
        ],
      ),
    );
  }

  // Rows/columns may contain multiple _Box leaves; wrap the whole subtree.
  Widget _wrapShimmer(Widget w) => AppShimmer(child: w);
}

class _LabelValueRow extends StatelessWidget {
  const _LabelValueRow();
  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        _Box(18, 18, radius: 4),
        SizedBox(width: 10),
        Expanded(child: _Box(double.infinity, 12)),
        SizedBox(width: 10),
        _Box(60, 12),
      ],
    );
  }
}

class _ContactRowSkeleton extends StatelessWidget {
  const _ContactRowSkeleton();
  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        _Box(36, 36, radius: 8), // leading icon box
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Box(double.infinity, 13),
              SizedBox(height: 6),
              _Box(80, 11),
            ],
          ),
        ),
        SizedBox(width: 12),
        _Box(28, 28, radius: 14), // trailing action
      ],
    );
  }
}

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
