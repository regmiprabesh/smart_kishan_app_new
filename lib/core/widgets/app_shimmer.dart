import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';

/// A lightweight shimmer effect with no external dependency. Wrap any widget
/// (or use [AppShimmer.box] for a plain shimmering rectangle). A moving
/// gradient sweeps across the child's shape. Reused for image placeholders and
/// list skeletons.
class AppShimmer extends StatefulWidget {
  const AppShimmer({super.key, required this.child});

  /// The shape to shimmer — typically a Container with the target size/radius.
  final Widget child;

  /// Convenience: a shimmering rounded rectangle of the given size.
  factory AppShimmer.box({
    Key? key,
    double? width,
    double height = 16,
    double radius = 8,
  }) {
    return AppShimmer(
      key: key,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final base = colors.surfaceAlt;
    final highlight = colors.border.withValues(alpha: 0.35);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            final dx = bounds.width;
            // Sweep the highlight band left→right.
            final slide = (_controller.value * 2 - 1) * dx;
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [base, highlight, base],
              stops: const [0.35, 0.5, 0.65],
              transform: _SlideGradient(slide),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Translates a gradient horizontally for the sweep.
class _SlideGradient extends GradientTransform {
  const _SlideGradient(this.dx);
  final double dx;
  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(dx, 0, 0);
}
