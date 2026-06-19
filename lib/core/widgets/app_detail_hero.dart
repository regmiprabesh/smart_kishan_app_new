import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/widgets/app_image_preview.dart';
import 'package:smart_kishan/core/widgets/app_network_image.dart';

/// Full-bleed hero image for detail screens that have NO AppBar (crop info,
/// farmland). By default the image starts BELOW the status bar, with a
/// neutral [surfaceAlt] backdrop + gradient fade + frosted strip keeping
/// status-bar icons legible. Set [imageUnderStatusBar] to true to let the
/// image itself extend under the status bar instead (true full-bleed).
///
/// Title/description belong in the body BELOW this widget — they are not
/// overlaid on the image. Pair with [AppGlassBackButton] in the screen's Stack.
class AppDetailHero extends StatelessWidget {
  const AppDetailHero({
    super.key,
    required this.imageUrl,
    required this.fallbackIcon,
    this.fit = BoxFit.cover,
    this.height = 280,
    this.imageUnderStatusBar = false,
  });

  /// Image to show. When null/empty, a centered [fallbackIcon] is shown.
  final String? imageUrl;

  /// Icon shown when there's no image (and as the broken-image fallback).
  final IconData fallbackIcon;

  /// Use [BoxFit.cover] for photos, [BoxFit.contain] for transparent artwork.
  final BoxFit fit;

  /// Hero height BELOW the status bar (the widget adds the top inset on top).
  final double height;

  /// When true, the image extends under the status bar (true full-bleed).
  /// When false (default), the image starts below the status bar and a
  /// [colors.surfaceAlt] backdrop fills the status-bar zone instead.
  final bool imageUnderStatusBar;

  bool get _hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final topInset = MediaQuery.paddingOf(context).top;

    final imageContent = _hasImage
        ? AppNetworkImage(url: imageUrl, fit: fit, fallbackIcon: fallbackIcon)
        : Center(
            child: Icon(
              fallbackIcon,
              size: 64,
              color: colors.primary.withValues(alpha: 0.4),
            ),
          );

    return GestureDetector(
      onTap: _hasImage
          ? () => AppImagePreview.open(context, imageUrls: [imageUrl!])
          : null,
      child: SizedBox(
        height: topInset + height,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Backdrop only needed when the image stops below the status
            // bar — gives the fade/frosted strip a neutral surface to sit on.
            if (!imageUnderStatusBar) Container(color: colors.surfaceAlt),

            // Image fills the whole stack when imageUnderStatusBar is true;
            // otherwise it starts right where the fade ends.
            imageUnderStatusBar
                ? Positioned.fill(child: imageContent)
                : Positioned(
                    top: topInset,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: imageContent,
                  ),

            // Gradient fade so status-bar icons stay legible — sits over
            // the image directly when imageUnderStatusBar is true, or over
            // the plain backdrop otherwise.
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: topInset + 56,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.35),
                        Colors.black.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Frosted strip behind the status bar, the blur itself fading out
            // via a gradient mask.
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: topInset + 36,
              child: IgnorePointer(
                child: ClipRect(
                  child: ShaderMask(
                    shaderCallback: (rect) => const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white, Colors.transparent],
                    ).createShader(rect),
                    blendMode: BlendMode.dstIn,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
