import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// GEOMETRY-ONLY text theme: sizes, weights, fonts — and deliberately
/// NO colors. Ink color is applied exactly once in AppTheme._build()
/// from AppColorScheme, which is what makes text brightness-correct in
/// both modes automatically.
///
/// THE BUG THIS REPLACES: GoogleFonts.nunitoTextTheme() bakes explicit
/// BLACK colors into every style. ThemeData honors explicit colors, so
/// in dark mode the text stayed black on a dark background → invisible.
/// Rule from now on: if a TextStyle in this file has a `color:`, it's
/// a bug.
///
/// Fonts: Nunito for Latin with per-glyph fallback to NotoSansDevanagari
/// — both scripts always active, so language switches don't change the
/// theme (no transition) and mixed ne/en strings render correctly.
abstract final class AppTextStyles {
  static TextTheme get textTheme {
    final latin = GoogleFonts.nunito().fontFamily;
    const devanagari = 'NotoSansDevanagari'; // bundled asset font

    // englishLike = Material's geometry-only typography (all colors null).
    final base = Typography.material2021().englishLike.apply(
      fontFamily: latin,
      fontFamilyFallback: const [devanagari],
    );

    TextStyle? s(TextStyle? style, double size, FontWeight weight) =>
        style?.copyWith(fontSize: size, fontWeight: weight);

    // Your scale, preserved from the old helper:
    return base.copyWith(
      displayLarge: s(base.displayLarge, 52, FontWeight.w700),
      displayMedium: s(base.displayMedium, 42, FontWeight.w700),
      titleLarge: s(base.titleLarge, 20, FontWeight.w600),
      titleMedium: s(base.titleMedium, 18, FontWeight.w600),
      bodyLarge: s(base.bodyLarge, 16, FontWeight.w400),
      bodyMedium: s(base.bodyMedium, 14, FontWeight.w400),
      labelLarge: s(base.labelLarge, 14, FontWeight.w600),
      labelSmall: s(base.labelSmall, 11, FontWeight.w400),
    );
  }
}
