import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_kishan/app/router/app_routes.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';

/// Home banner that links to the crop info list. Polished take on the original:
/// background image + gradient scrim + title/subtitle, plus a small "explore"
/// affordance and a decorative leaf glyph. Tap → crop list.
class CropInfoBanner extends StatelessWidget {
  const CropInfoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: () => context.push(AppRoutePath.cropInfoList),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background image
                Image.asset(
                  'assets/images/crop_banner_image.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: context.colors.primary),
                ),
                // Gradient scrim (stronger at bottom-left for text legibility)
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.black.withValues(alpha: 0.15),
                        Colors.black.withValues(alpha: 0.65),
                      ],
                    ),
                  ),
                ),
                // Decorative glyph (subtle, top-right)
                Positioned(
                  right: -10,
                  top: -10,
                  child: Icon(
                    Icons.eco_rounded,
                    size: 110,
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
                // Text + explore affordance
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        l10n.cropInfoBannerTitle,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.cropInfoBannerSubtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            l10n.cropInfoBannerExplore,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
