import 'package:flutter/material.dart';
import 'app_colors.dart';

@immutable
class AppColorScheme {
  const AppColorScheme._({
    required this.primary,
    required this.primaryLight,
    required this.primaryDark,
    required this.secondary,
    required this.secondaryLight,
    required this.error,
    required this.errorLight,
    required this.success,
    required this.successLight,
    required this.warning,
    required this.warningLight,
    required this.info,
    required this.infoLight,
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.border,
    required this.divider,
    required this.shimmerBase,
    required this.shimmerHighlight,
    required this.textPrimary,
    required this.textSecondary,
    required this.textHint,
    required this.textDisabled,
    required this.iconPrimary,
    required this.iconSecondary,
    required this.cardTitle,
    required this.cardSubtitle,
    required this.shadow,
    required this.rating,
    required this.tileColors,
    required this.govServiceGradients,
  });

  // ── Brand ──────────────────────────────────────────────────────────────
  final Color primary;
  final Color primaryLight;
  final Color primaryDark;
  final Color secondary;
  final Color secondaryLight;

  // ── Semantic ───────────────────────────────────────────────────────────
  final Color error;
  final Color errorLight;
  final Color success;
  final Color successLight;
  final Color warning;
  final Color warningLight;
  final Color info;
  final Color infoLight;

  // ── Surface ────────────────────────────────────────────────────────────
  final Color background;
  final Color surface;
  final Color surfaceAlt;
  final Color border;
  final Color divider;
  final Color shimmerBase;
  final Color shimmerHighlight;

  // ── Text ───────────────────────────────────────────────────────────────
  final Color textPrimary;
  final Color textSecondary;
  final Color textHint;
  final Color textDisabled;

  // ── Icon ───────────────────────────────────────────────────────────────
  final Color iconPrimary;
  final Color iconSecondary;

  // ── Card ───────────────────────────────────────────────────────────────
  final Color cardTitle;
  final Color cardSubtitle;

  // Shadow
  final Color shadow;

  // Rating
  final Color rating;

  // Tile
  final List<Color> tileColors;

  //Governemt Service Card Colors
  final List<List<Color>> govServiceGradients;

  // ── Factories ──────────────────────────────────────────────────────────

  static const light = AppColorScheme._(
    primary: AppColors.primary,
    primaryLight: AppColors.primaryLight,
    primaryDark: AppColors.primaryDark,
    secondary: AppColors.secondary,
    secondaryLight: AppColors.secondaryLight,
    error: AppColors.error,
    errorLight: AppColors.errorLight,
    success: AppColors.success,
    successLight: AppColors.successLight,
    warning: AppColors.warning,
    warningLight: AppColors.warningLight,
    info: AppColors.info,
    infoLight: AppColors.infoLight,
    background: AppColors.backgroundL,
    surface: AppColors.surfaceL,
    surfaceAlt: AppColors.surfaceAltL,
    border: AppColors.borderL,
    divider: AppColors.dividerL,
    shimmerBase: AppColors.shimmerBaseL,
    shimmerHighlight: AppColors.shimmerHighlightL,
    textPrimary: AppColors.textPrimaryL,
    textSecondary: AppColors.textSecondaryL,
    textHint: AppColors.textHintL,
    textDisabled: AppColors.textDisabledL,
    iconPrimary: AppColors.iconPrimaryL,
    iconSecondary: AppColors.iconSecondaryL,
    cardTitle: AppColors.cardTitleL,
    cardSubtitle: AppColors.cardSubtitleL,
    shadow: AppColors.shadowL,
    rating: AppColors.ratingL,
    tileColors: [
      AppColors.tileBlueL,
      AppColors.tileTealL,
      AppColors.tilePinkL,
      AppColors.tileOrangeL,
      AppColors.tilePurpleL,
      AppColors.tileCyanL,
    ],
    govServiceGradients: [
      AppColors.govGreenCyanL,
      AppColors.govGreenAmberL,
      AppColors.govRedOrangeL,
      AppColors.govPurpleIndigoL,
    ],
  );

  static const dark = AppColorScheme._(
    primary: AppColors.primary,
    primaryLight: AppColors.primaryDark, // inverted role in dark mode
    primaryDark: AppColors.primaryLight,
    secondary: AppColors.secondary,
    secondaryLight: Color(0xFF5C2918), // dark surface tint of secondary
    error: AppColors.error,
    errorLight: Color(0xFF3B1010),
    success: AppColors.success,
    successLight: Color(0xFF0E3D07),
    warning: AppColors.warning,
    warningLight: Color(0xFF3D2A00),
    info: Color(0xFF60A5FA), // lightened for dark bg readability
    infoLight: Color(0xFF1E3A5F),
    background: AppColors.backgroundD,
    surface: AppColors.surfaceD,
    surfaceAlt: AppColors.surfaceAltD,
    border: AppColors.borderD,
    divider: AppColors.dividerD,
    shimmerBase: AppColors.shimmerBaseD,
    shimmerHighlight: AppColors.shimmerHighlightD,
    textPrimary: AppColors.textPrimaryD,
    textSecondary: AppColors.textSecondaryD,
    textHint: AppColors.textHintD,
    textDisabled: AppColors.textDisabledD,
    iconPrimary: AppColors.iconPrimaryD,
    iconSecondary: AppColors.iconSecondaryD,
    cardTitle: AppColors.cardTitleD,
    cardSubtitle: AppColors.cardSubtitleD,
    shadow: AppColors.shadowD,
    rating: AppColors.ratingD,

    tileColors: [
      AppColors.tileBlueD,
      AppColors.tileTealD,
      AppColors.tilePinkD,
      AppColors.tileOrangeD,
      AppColors.tilePurpleD,
      AppColors.tileCyanD,
    ],
    govServiceGradients: [
      AppColors.govGreenCyanD,
      AppColors.govGreenAmberD,
      AppColors.govRedOrangeD,
      AppColors.govPurpleIndigoD,
    ],
  );
}
