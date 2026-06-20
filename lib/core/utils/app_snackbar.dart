import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_colors.dart';

/// Global key wired to MaterialApp.router(scaffoldMessengerKey: ...) —
/// snackbars work from anywhere without a BuildContext.
final rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

/// The ONLY way to show feedback. RULE: pass ALREADY-LOCALIZED strings
/// (l10n.xyz) — never raw literals; that's what broke multilinguality.
abstract final class AppSnackbar {
  static const _warningColor = AppColors.warning;
  static const _infoColor = AppColors.info;

  static void success(String message) =>
      _show(message, AppColors.success, Icons.check_circle_outline);

  static void error(String message) =>
      _show(message, AppColors.error, Icons.error_outline);

  static void warning(String message) =>
      _show(message, _warningColor, Icons.warning_amber_rounded);

  static void info(String message) =>
      _show(message, _infoColor, Icons.info_outline);

  static void _show(String message, Color color, IconData icon) {
    final messenger = rootScaffoldMessengerKey.currentState;
    if (messenger == null) return;

    messenger
      ..hideCurrentSnackBar() // never stack/queue messages
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: color,
          margin: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 3),
          content: Row(
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
