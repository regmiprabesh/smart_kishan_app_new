import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/widgets/app_network_image.dart';

import '../ratings_config.dart';

/// "What am I rating?" header: a leading image (or fallback icon) with the
/// entity title (1 line) and short description (max 2 lines). Fully optional —
/// renders nothing when the config carries no title/description/image, so
/// features that don't set them are unaffected.
class RatingsEntityHeader extends StatelessWidget {
  const RatingsEntityHeader({super.key, required this.config});

  final RatingsConfig config;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final hasTitle = config.title?.trim().isNotEmpty == true;
    final hasDesc = config.description?.trim().isNotEmpty == true;
    final hasImage = config.imageUrl?.trim().isNotEmpty == true;
    if (!hasTitle && !hasDesc && !hasImage) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            height: 56,
            // AppNetworkImage shows fallbackIcon when url is null/empty/fails.
            child: AppNetworkImage(
              url: config.imageUrl,
              fit: BoxFit.cover,
              fallbackIcon: config.fallbackIcon,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasTitle)
                  Text(
                    config.title!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                if (hasDesc) ...[
                  const SizedBox(height: 3),
                  Text(
                    config.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.35,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
