import 'package:flutter/material.dart';

abstract final class AppColors {
  // ── Brand ──────────────────────────────────────────────────────────────
  static const primary = Color(0xFF1A7A4A);
  static const primaryLight = Color(0xFFD6EBE0);
  static const primaryDark = Color(0xFF15663E); // pressed / dark-mode accent
  static const secondary = Color(0xFFFE724C);
  static const secondaryLight = Color(0xFFFFDDD4);

  // ── Semantic ───────────────────────────────────────────────────────────
  static const error = Color(0xFFEB1D1D);
  static const errorLight = Color(0xFFFFEBEB);
  static const success = Color(0xFF23B502);
  static const successLight = Color(0xFFE6F9E3);
  static const warning = Color(0xFFF59E0B);
  static const warningLight = Color(0xFFFEF3C7);
  static const info = Color(0xFF5B8DEF);
  static const infoLight = Color(0xFFEFF6FF);

  // ── Light neutrals ─────────────────────────────────────────────────────
  static const white = Color(0xFFFFFFFF);
  static const backgroundL = Color(0xFFF8F9FA); // scaffold
  static const surfaceL = Color(0xFFFFFFFF); // cards, sheets, dialogs
  static const surfaceAltL = Color(0xFFF1F3F5); // input fills, chips
  static const borderL = Color(0xFFE4E7EB);
  static const dividerL = Color(0xFFEEF0F2);
  static const shimmerBaseL = Color(0xFFE0E0E0);
  static const shimmerHighlightL = Color(0xFFF5F5F5);

  // ── Dark neutrals ──────────────────────────────────────────────────────
  static const backgroundD = Color(0xFF111827); // scaffold
  static const surfaceD = Color(0xFF1F2937); // cards, sheets
  static const surfaceAltD = Color.fromARGB(
    255,
    22,
    25,
    29,
  ); // input fills, chips
  static const borderD = Color(0xFF374151);
  static const dividerD = Color(0xFF374151);
  static const shimmerBaseD = Color(0xFF374151);
  static const shimmerHighlightD = Color(0xFF4B5563);

  // ── Text – light surface ───────────────────────────────────────────────
  static const textPrimaryL = Color(0xDD000000);
  static const textSecondaryL = Color(0xFF6B7280);
  static const textHintL = Color(0xFF9CA3AF);
  static const textDisabledL = Color(0xFFD1D5DB);

  // ── Text – dark surface ────────────────────────────────────────────────
  static const textPrimaryD = Color(0xFFF9FAFB);
  static const textSecondaryD = Color(0xFF9E9E9E);
  static const textHintD = Color(0xFF6B7280);
  static const textDisabledD = Color(0xFF374151);

  // ── Icon ───────────────────────────────────────────────────────────────
  static const iconPrimaryL = Color(0xFF374151);
  static const iconSecondaryL = Color(0xFFE0E0E0);
  static const iconPrimaryD = Color(0xFFD1D5DB);
  static const iconSecondaryD = Color(0xFF6B7280);

  // ── Card / list item copy (kept from original design) ──────────────────
  static const cardTitleL = Color(0xFF292D32);
  static const cardSubtitleL = Color(0xFF898A8D);
  static const cardTitleD = Color(0xFFE5E7EB);
  static const cardSubtitleD = Color(0xFF9CA3AF);

  // Shadow
  static const shadowL = Color(0x14000000);
  static const shadowD = Color(0x14000000);

  //Rating
  static const ratingL = Color(0xFFFFC107);
  static const ratingD = Color(0xFFFFB300);

  //  Tile accents Light
  static const tileBlueL = Color(0xFF4A90E2);
  static const tileTealL = Color(0xFF26C6A6);
  static const tilePinkL = Color(0xFFEF5777);
  static const tileOrangeL = Color(0xFFF5A623);
  static const tilePurpleL = Color(0xFF9B6BDF);
  static const tileCyanL = Color(0xFF22B8CF);

  //  Tile accents Dark
  static const tileBlueD = Color(0xFF3A6EA5);
  static const tileTealD = Color(0xFF1E9C84);
  static const tilePinkD = Color(0xFFC2455F);
  static const tileOrangeD = Color(0xFFC98417);
  static const tilePurpleD = Color(0xFF7B54B0);
  static const tileCyanD = Color(0xFF1B93A3);

  //  Gov service gradients — Light  (start → end)
  static const govGreenCyanL = <Color>[Color(0xFF1FA463), Color(0xFF00ACC1)];
  static const govGreenAmberL = <Color>[Color(0xFF1FA463), Color(0xFFFFB300)];
  static const govRedOrangeL = <Color>[Color(0xFFE53935), Color(0xFFFB8C00)];
  static const govPurpleIndigoL = <Color>[Color(0xFF8E24AA), Color(0xFF5E35B1)];

  //  Gov service gradients — Dark (deepened)
  static const govGreenCyanD = <Color>[Color(0xFF15784A), Color(0xFF0E8194)];
  static const govGreenAmberD = <Color>[Color(0xFF15784A), Color(0xFFC98417)];
  static const govRedOrangeD = <Color>[Color(0xFFB02A28), Color(0xFFC2680C)];
  static const govPurpleIndigoD = <Color>[Color(0xFF6E1C84), Color(0xFF45289A)];

  // Brand header / drawer gradient (deep greens, darker than primaryDark)
  static const headerDeep = Color(0xFF062318); // darkest — dark-mode top
  static const headerDark = Color(0xFF0E4F2F); // shared mid-dark
  static const headerMid = Color(0xFF1A7A4A); // light-mode bottom
}
