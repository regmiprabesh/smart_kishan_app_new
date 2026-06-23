import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';

/// A row of 5 tappable emoji segments. Each shows the emoji and its numeric
/// index; the selected one is highlighted with a semantic color drawn from the
/// app theme. Replaces both [StarRating] and the separate emoji/label row on
/// the rate page.
///
/// Pass [onChanged] to make it interactive; omit for a read-only display.
class SatisfactionRating extends StatelessWidget {
  const SatisfactionRating({super.key, required this.rating, this.onChanged});

  final int rating;
  final ValueChanged<int>? onChanged;

  static const _emojis = ['😞', '😕', '🙂', '😀', '🤩'];

  /// Semantic color for a 1–5 rating, from the theme — so it adapts to
  /// light/dark and any palette change. Exposed so callers (e.g. the live
  /// label on the rate page) can match a segment's color.
  static Color colorOf(BuildContext context, int rating) {
    final c = context.colors;
    return switch (rating) {
      1 => c.error,
      2 => c.warning,
      3 => c.textSecondary,
      4 => c.success,
      5 => c.info,
      _ => c.textSecondary,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (i) {
        final value = i + 1;
        final selected = rating == value;
        final color = colorOf(context, value);

        final segment = AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          decoration: BoxDecoration(
            color: selected
                ? color.withValues(alpha: 0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected
                  ? color.withValues(alpha: 0.5)
                  : context.colors.border.withValues(alpha: 0.4),
              width: 0.5,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_emojis[i], style: const TextStyle(fontSize: 22)),
              const SizedBox(height: 4),
              Text(
                '$value',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: selected ? color : context.colors.textSecondary,
                ),
              ),
            ],
          ),
        );

        final padded = Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: segment,
        );

        if (onChanged == null) return Expanded(child: padded);

        return Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onChanged!(value),
            child: padded,
          ),
        );
      }),
    );
  }
}
