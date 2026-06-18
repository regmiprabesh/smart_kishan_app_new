import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/widgets/app_network_image.dart';
import 'package:smart_kishan/core/widgets/app_image_preview.dart';
import '../data/crop_info.dart';

/// Crop detail: full-bleed hero image (tap → preview), name + description, then
/// the cultivation activities as expandable sections. Frosted back button.
class CropInfoDetailScreen extends StatelessWidget {
  const CropInfoDetailScreen({super.key, required this.crop});
  final CropInfo crop;

  bool get _hasImage => crop.image != null && crop.image!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final topInset = MediaQuery.paddingOf(context).top;

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero image — starts below the status bar fade zone so a
                // transparent-background PNG doesn't show the blur/gradient
                // floating over empty space; only the surfaceAlt backdrop
                // sits behind the fade, and the artwork begins right where
                // the fade ends.
                GestureDetector(
                  onTap: _hasImage
                      ? () => AppImagePreview.open(
                          context,
                          imageUrls: [crop.image!],
                        )
                      : null,
                  child: SizedBox(
                    height: topInset + 280,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Backdrop fills the whole band, including the
                        // status-bar zone, so the fade above has something
                        // neutral to sit on.
                        Container(color: colors.surfaceAlt),
                        // Image itself starts right where the fade ends.
                        Positioned(
                          top: topInset,
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: _hasImage
                              ? AppNetworkImage(
                                  url: crop.image,
                                  fit: BoxFit.contain,
                                  fallbackIcon: Icons.eco_rounded,
                                )
                              : Center(
                                  child: Icon(
                                    Icons.eco_rounded,
                                    size: 64,
                                    color: colors.primary.withValues(
                                      alpha: 0.4,
                                    ),
                                  ),
                                ),
                        ),
                        // Gradient fade so status bar icons stay legible —
                        // now sitting over the plain backdrop, not the image.
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
                        // Frosted strip behind the status bar, with the blur
                        // itself fading out via a gradient mask.
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          height: topInset + 36,
                          child: IgnorePointer(
                            child: ClipRect(
                              child: ShaderMask(
                                shaderCallback: (rect) => LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: const [
                                    Colors.white,
                                    Colors.transparent,
                                  ],
                                ).createShader(rect),
                                blendMode: BlendMode.dstIn,
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 10,
                                    sigmaY: 10,
                                  ),
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
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        crop.name?.of(context) ?? '',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: colors.textPrimary,
                        ),
                      ),
                      if (crop.description?.of(context) != null &&
                          crop.description!.of(context).isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          crop.description!.of(context),
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.6,
                            color: colors.textSecondary,
                          ),
                        ),
                      ],

                      // Cultivation activities
                      if (crop.activities.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        _ActivitiesCard(activities: crop.activities),
                      ],
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Frosted back button
          Positioned(
            top: topInset + 8,
            left: 12,
            child: _GlassBackButton(onTap: () => context.pop()),
          ),
        ],
      ),
    );
  }
}

/// Activities as expandable sections (first two open by default, like original).
class _ActivitiesCard extends StatelessWidget {
  const _ActivitiesCard({required this.activities});
  final List<CropActivity> activities;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        // Remove the default ExpansionTile divider lines for a cleaner look.
        data: Theme.of(context).copyWith(dividerColor: colors.divider),
        child: Column(
          children: [
            for (var i = 0; i < activities.length; i++)
              ExpansionTile(
                initiallyExpanded: i == 0 || i == 1,
                // Match the ink splash's clip to the card's own rounded
                // corners on the first/last tile — otherwise InkWell clips
                // to a plain rectangle and the splash spills past the curve.
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: i == 0 ? const Radius.circular(16) : Radius.zero,
                    bottom: i == activities.length - 1
                        ? const Radius.circular(16)
                        : Radius.zero,
                  ),
                ),
                collapsedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: i == 0 ? const Radius.circular(16) : Radius.zero,
                    bottom: i == activities.length - 1
                        ? const Radius.circular(16)
                        : Radius.zero,
                  ),
                ),
                tilePadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                expandedAlignment: Alignment.centerLeft,
                title: Text(
                  activities[i].title?.of(context) ?? '',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      activities[i].description?.of(context) ?? '',
                      style: TextStyle(
                        fontSize: 13.5,
                        height: 1.6,
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _GlassBackButton extends StatelessWidget {
  const _GlassBackButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Material(
          color: Colors.black.withValues(alpha: 0.28),
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Icon(CupertinoIcons.back, color: Colors.white, size: 22),
            ),
          ),
        ),
      ),
    );
  }
}
