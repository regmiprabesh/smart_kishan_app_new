import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_color_scheme.dart';
import 'package:smart_kishan/app/theme/app_text_styles.dart';

/// Bridges [AppColorScheme] into Flutter's theme system so widgets can do:
///
///   context.colors.primary
///   context.colors.textSecondary
///
/// Widgets NEVER import AppColors / AppColorScheme directly — they go
/// through `context.colors`, which resolves light/dark automatically.
@immutable
class AppColorsTheme extends ThemeExtension<AppColorsTheme> {
  const AppColorsTheme(this.colors);

  final AppColorScheme colors;

  @override
  AppColorsTheme copyWith({AppColorScheme? colors}) =>
      AppColorsTheme(colors ?? this.colors);

  /// AppColorScheme's constructor is private, so interpolated instances
  /// can't be built — snap at the midpoint instead. Only visible as a
  /// non-crossfaded color change during an animated theme switch.
  @override
  AppColorsTheme lerp(AppColorsTheme? other, double t) =>
      t < 0.5 ? this : (other ?? this);
}

/// `context.colors.<anything>` — the one way widgets read colors.
extension AppColorsX on BuildContext {
  AppColorScheme get colors =>
      Theme.of(this).extension<AppColorsTheme>()?.colors ??
      AppColorScheme.light;
}

abstract final class AppTheme {
  static ThemeData light() => _build(AppColorScheme.light, Brightness.light);

  static ThemeData dark() => _build(AppColorScheme.dark, Brightness.dark);

  /// ONE builder for both modes — the two themes can never drift apart
  /// structurally; only the color bag differs.
  static ThemeData _build(AppColorScheme c, Brightness brightness) {
    const onBrand = Color(0xFFFFFFFF); // text/icons on primary/secondary

    // Map our bag onto Material's roles so STOCK widgets (date pickers,
    // menus, dialogs, chips...) also adapt — not just our own widgets.
    final scheme = ColorScheme(
      brightness: brightness,
      primary: c.primary,
      onPrimary: onBrand,
      primaryContainer: c.primaryLight,
      onPrimaryContainer: c.textPrimary,
      secondary: c.secondary,
      onSecondary: onBrand,
      secondaryContainer: c.secondaryLight,
      onSecondaryContainer: c.textPrimary,
      error: c.error,
      onError: onBrand,
      errorContainer: c.errorLight,
      onErrorContainer: c.textPrimary,
      surface: c.surface,
      onSurface: c.textPrimary,
      onSurfaceVariant: c.textSecondary,
      surfaceContainerHighest: c.surfaceAlt,
      outline: c.border,
      outlineVariant: c.divider,
      shadow: Colors.black,
      scrim: Colors.black54,
      inverseSurface: c.textPrimary,
      onInverseSurface: c.surface,
      inversePrimary: c.primaryLight,
    );

    // Geometry from AppTextStyles + ink color applied HERE, once, from
    // the color bag. decorationColor too (underlines etc.).
    final textTheme = AppTextStyles.textTheme.apply(
      bodyColor: c.textPrimary,
      displayColor: c.textPrimary,
      decorationColor: c.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      extensions: [AppColorsTheme(c)],

      scaffoldBackgroundColor: c.background,
      canvasColor: c.surface,
      dividerColor: c.divider,
      textTheme: textTheme,

      appBarTheme: AppBarTheme(
        backgroundColor: brightness == Brightness.dark ? c.surface : c.primary,
        foregroundColor: brightness == Brightness.dark
            ? c.textPrimary
            : onBrand,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: brightness == Brightness.dark
            ? Border(bottom: BorderSide(color: c.border, width: 1))
            : null,
        titleTextStyle: textTheme.titleMedium?.copyWith(
          color: brightness == Brightness.dark ? c.textPrimary : onBrand,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(
          color: brightness == Brightness.dark ? c.iconPrimary : onBrand,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: c.primary,
          foregroundColor: onBrand,
          disabledBackgroundColor: c.textDisabled,
          disabledForegroundColor: c.textHint,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: c.primary,
          side: BorderSide(color: c.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: c.primaryDark),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.surfaceAlt,
        hintStyle: textTheme.bodyMedium?.copyWith(color: c.textHint),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: c.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: c.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: c.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: c.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: c.error, width: 1.5),
        ),
      ),

      cardTheme: CardThemeData(
        color: c.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: c.border),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: c.surface,
        surfaceTintColor: Colors.transparent,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.surface,
        surfaceTintColor: Colors.transparent,
      ),
      dividerTheme: DividerThemeData(color: c.divider, thickness: 1),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: c.surface,
        selectedItemColor: c.primary,
        unselectedItemColor: c.iconSecondary,
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: c.primary,
        foregroundColor: onBrand,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: c.primary),
      iconTheme: IconThemeData(color: c.iconPrimary),
      listTileTheme: ListTileThemeData(
        iconColor: c.iconPrimary,
        textColor: c.textPrimary,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: c.surfaceAlt,
        side: BorderSide(color: c.border),
        labelStyle: textTheme.bodySmall?.copyWith(color: c.textPrimary),
      ),
    );
  }
}
