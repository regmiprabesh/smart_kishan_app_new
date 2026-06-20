import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, this.height = 170});

  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final topInset = MediaQuery.paddingOf(context).top;
    final canPop = GoRouter.of(context).canPop();

    final size = MediaQuery.sizeOf(context);
    final isLandscape = size.width > size.height;
    final effectiveHeight = isLandscape ? 90.0 : height;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: ClipRect(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Top-right: large primary circle bleeding off the corner.
            Positioned(
              right: -80,
              top: -70,
              child: _Circle(diameter: 150, color: colors.primary),
            ),

            // Left cluster: soft secondary circle behind...
            Positioned(
              left: 10,
              top: -70,
              child: _Circle(
                diameter: 150,
                color: colors.secondary.withValues(alpha: 0.6),
              ),
            ),
            // ...primary circle with the small dot in front.
            Positioned(
              left: -60,
              top: 10,
              child: _Circle(
                diameter: 110,
                color: colors.primary,
                child: Center(
                  child: _Circle(diameter: 30, color: colors.surface),
                ),
              ),
            ),

            if (canPop)
              Positioned(
                left: 16,
                top: topInset + 8,
                child: _BackButton(onTap: () => context.pop()),
              ),
          ],
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: colors.surface,
      shape: const CircleBorder(),
      elevation: 2,
      shadowColor: context.colors.shadow,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          height: 42,
          width: 42,
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: colors.iconPrimary,
          ),
        ),
      ),
    );
  }
}

class _Circle extends StatelessWidget {
  const _Circle({required this.diameter, required this.color, this.child});

  final double diameter;
  final Color color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: diameter,
      width: diameter,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: child,
    );
  }
}
