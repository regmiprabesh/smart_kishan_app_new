import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';

/// Themed 6-digit code input (pinput 6.x).
///
/// pinput 6 DROPPED its built-in smart_auth/SMS-autofill integration, so
/// this widget is pure presentation again. Autofill is driven from the
/// SCREEN:
///   • iOS    — automatic via the oneTimeCode hint pinput sets internally
///              (QuickType bar). Nothing to wire.
///   • Android — the screen listens with smart_auth and calls
///              controller.setText(code); see OtpScreen + AppSmsListener.
///
/// Styling lives here once and follows the color bag (dark-mode safe).
class OtpInput extends StatelessWidget {
  const OtpInput({
    super.key,
    required this.controller,
    this.length = 6,
    this.onCompleted,
  });

  final TextEditingController controller;
  final int length;
  final void Function(String)? onCompleted;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final base = PinTheme(
      width: 48,
      height: 56,
      textStyle: Theme.of(context).textTheme.titleLarge,
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.border),
      ),
    );

    return Pinput(
      controller: controller,
      length: length,
      autofocus: true,
      keyboardType: TextInputType.number,
      defaultPinTheme: base,
      focusedPinTheme: base.copyWith(
        decoration: base.decoration!.copyWith(
          border: Border.all(color: colors.primary, width: 1.5),
        ),
      ),
      submittedPinTheme: base,
      errorPinTheme: base.copyWith(
        decoration: base.decoration!.copyWith(
          border: Border.all(color: colors.error),
        ),
      ),
      onCompleted: onCompleted,
    );
  }
}
