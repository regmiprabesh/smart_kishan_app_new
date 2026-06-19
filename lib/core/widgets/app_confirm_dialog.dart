import 'package:flutter/material.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';

import '../../app/theme/app_theme.dart';

/// Reusable confirm dialog. Returns true if confirmed.
///   final ok = await AppConfirmDialog.show(context, title: ..., message: ...);
///
/// For deletes prefer [AppConfirmDialog.delete], which bakes in the standard
/// delete/cancel labels + destructive styling so every delete looks identical.
class AppConfirmDialog {
  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    required String cancelLabel,
    bool destructive = false,
  }) async {
    final colors = context.colors;
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              cancelLabel,
              style: TextStyle(color: colors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              confirmLabel,
              style: TextStyle(
                color: destructive ? colors.error : colors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Standard "delete this item?" confirm — the uniform delete dialog used
  /// across the app. Callers pass only [title] and [message]; the delete/
  /// cancel labels and destructive styling are fixed so deletes never drift.
  static Future<bool> delete(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return show(
      context,
      title: title,
      message: message,
      confirmLabel: l10n.commonDelete,
      cancelLabel: l10n.commonCancel,
      destructive: true,
    );
  }
}
