import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_kishan/app/theme/theme_cubit.dart';

/// Light/dark theme row with a custom animated pill toggle.
class ProfileThemeToggleRow extends StatelessWidget {
  const ProfileThemeToggleRow({super.key, required this.colors});
  final dynamic colors;

  @override
  Widget build(BuildContext context) {
    final primaryColor = colors.primary as Color;

    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final isOn = themeMode == ThemeMode.dark;

        return InkWell(
          onTap: () => context.read<ThemeCubit>().set(
            isOn ? ThemeMode.light : ThemeMode.dark,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: SizedBox(
              height: 52,
              child: Row(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder: (child, anim) =>
                        ScaleTransition(scale: anim, child: child),
                    child: Icon(
                      isOn
                          ? Icons.dark_mode_outlined
                          : Icons.light_mode_outlined,
                      key: ValueKey(isOn),
                      size: 22,
                      color: colors.textSecondary as Color,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      // TODO: add l10n keys darkMode / lightMode
                      isOn ? 'Dark Mode' : 'Light Mode',
                      style: TextStyle(
                        fontSize: 15,
                        color: colors.textPrimary as Color,
                      ),
                    ),
                  ),
                  _ThemePillToggle(
                    isOn: isOn,
                    primaryColor: primaryColor,
                    onTap: () => context.read<ThemeCubit>().set(
                      isOn ? ThemeMode.light : ThemeMode.dark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// A fully custom animated toggle — avoids Switch.adaptive's platform-specific
// inactive track styling which looks washed out on light mode Material 3.
//
// Light off: light grey track, white thumb with sun icon, dark icon tint
// Light on:  brand-green track, white thumb with moon icon
// Dark  off: dark track, white thumb with sun icon
// Dark  on:  brand-green track, white thumb with moon icon
class _ThemePillToggle extends StatelessWidget {
  const _ThemePillToggle({
    required this.isOn,
    required this.primaryColor,
    required this.onTap,
  });

  final bool isOn;
  final Color primaryColor;
  final VoidCallback onTap;

  static const double _w = 52.0;
  static const double _h = 28.0;
  static const double _thumb = 22.0;
  static const double _pad = 3.0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Track colour: green when on, a visible grey when off
    final trackColor = isOn
        ? primaryColor
        : isDark
        ? Colors.white.withValues(alpha: 0.15)
        : const Color(0xFFDDE1E7); // solid light grey — visible on white bg

    // Thumb slides between left (_pad) and right (_w - _thumb - _pad)
    final thumbX = isOn ? _w - _thumb - _pad : _pad;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        width: _w,
        height: _h,
        decoration: BoxDecoration(
          color: trackColor,
          borderRadius: BorderRadius.circular(_h / 2),
        ),
        child: Stack(
          children: [
            // Sliding thumb
            AnimatedPositioned(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOut,
              left: thumbX,
              top: _pad,
              child: Container(
                width: _thumb,
                height: _thumb,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: Icon(
                      isOn ? Icons.dark_mode : Icons.light_mode,
                      key: ValueKey(isOn),
                      size: 14,
                      color: isOn
                          ? primaryColor
                          : const Color(0xFFFFB300), // amber sun
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
