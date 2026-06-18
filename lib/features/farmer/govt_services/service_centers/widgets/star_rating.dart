import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';

/// A row of 1–5 stars. When [onChanged] is provided it's interactive (tap to
/// set); otherwise it's a read-only display of [rating]. Used by the rating
/// dialog (interactive) and review items / overview (read-only).
class StarRating extends StatelessWidget {
  const StarRating({
    super.key,
    required this.rating,
    this.onChanged,
    this.size = 24,
    this.color,
  });

  final int rating;
  final ValueChanged<int>? onChanged;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final starColor = color ?? context.colors.rating;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = i < rating;
        final star = Icon(
          filled ? Icons.star_rounded : Icons.star_outline_rounded,
          color: starColor,
          size: size,
        );
        if (onChanged == null) return star;
        return GestureDetector(
          onTap: () => onChanged!(i + 1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: star,
          ),
        );
      }),
    );
  }
}
