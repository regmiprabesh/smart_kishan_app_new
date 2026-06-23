import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';

/// A row of 1–5 stars. Interactive when [onChanged] is given (tap to set),
/// otherwise a read-only display. Shared across every rating surface.
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
          behavior: HitTestBehavior.opaque,
          onTap: () => onChanged!(i + 1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: star,
          ),
        );
      }),
    );
  }
}
