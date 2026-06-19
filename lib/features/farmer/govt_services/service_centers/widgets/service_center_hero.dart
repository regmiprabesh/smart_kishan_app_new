import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';

import '../data/service_center.dart';
import 'service_center_type_style.dart';

/// Image banner with a dark gradient scrim and the type + name overlaid.
/// Falls back to a tinted type-icon placeholder when there's no image (or it
/// fails to load) — so it works now and when images are added later.
class ServiceCenterHero extends StatelessWidget {
  const ServiceCenterHero({super.key, required this.center});
  final ServiceCenter center;

  @override
  Widget build(BuildContext context) {
    final typeColor = ServiceCenterTypeStyle.of(center.type);
    final hasImage = center.images != null && center.images!.isNotEmpty;

    return SizedBox(
      height: 210,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image or placeholder
          if (hasImage)
            Image.network(
              center.images!.first,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _placeholder(typeColor),
              loadingBuilder: (context, child, progress) =>
                  progress == null ? child : _placeholder(typeColor),
            )
          else
            _placeholder(typeColor),

          // Gradient scrim so white text stays readable over any image.
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black54],
                stops: [0.45, 1.0],
              ),
            ),
          ),

          // Featured pill (top-right)
          if (center.isFeatured)
            Positioned(top: 12, right: 12, child: _FeaturedPill()),

          // Title + type overlaid at the bottom
          Positioned(
            left: 16,
            right: 16,
            bottom: 14,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (center.type?.name != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: typeColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          ServiceCenterTypeStyle.iconOf(center.type),
                          size: 13,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          center.type!.name!.of(context),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 6),
                Text(
                  center.name?.of(context) ?? '',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 15, color: Colors.white),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        center.address?.of(context) ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
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

  Widget _placeholder(Color typeColor) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Soft diagonal gradient backdrop
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                typeColor.withValues(alpha: 0.22),
                typeColor.withValues(alpha: 0.06),
              ],
            ),
          ),
        ),

        // Oversized faint icon for texture, tucked into a corner
        Positioned(
          right: -20,
          bottom: -30,
          child: Icon(
            ServiceCenterTypeStyle.iconOf(center.type),
            size: 160,
            color: typeColor.withValues(alpha: 0.08),
          ),
        ),
      ],
    );
  }
}

class _FeaturedPill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: colors.rating,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, size: 12, color: Colors.white),
          const SizedBox(width: 3),
          Text(
            l10n.featured,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
