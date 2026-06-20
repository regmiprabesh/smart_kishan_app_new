import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/widgets/app_shimmer.dart';

/// A network image that NEVER breaks the page: shimmer while loading, a clean
/// fallback on error (broken URL, 404, no connection), and handles null/empty
/// url by showing the fallback. Used everywhere images are displayed.
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.fallbackIcon = Icons.image_outlined,
    this.borderRadius,
  });

  final String? url;
  final BoxFit fit;
  final IconData fallbackIcon;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    Widget child;
    if (url == null || url!.isEmpty) {
      child = _fallback(colors);
    } else {
      child = CachedNetworkImage(
        imageUrl: url!,
        fit: fit,
        placeholder: (_, __) =>
            AppShimmer(child: Container(color: Colors.white)),
        errorWidget: (context, _, ___) => _fallback(colors),
      );
    }

    return borderRadius != null
        ? ClipRRect(borderRadius: borderRadius!, child: child)
        : child;
  }

  Widget _fallback(dynamic colors) => Container(
    color: colors.surfaceAlt,
    child: Center(
      child: Icon(fallbackIcon, color: colors.iconSecondary, size: 36),
    ),
  );
}
