import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_kishan/app/router/app_routes.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/features/auth/widgets/auth_flow_scaffold.dart';
import 'package:smart_kishan/features/auth/widgets/or_divider.dart';
import 'package:smart_kishan/features/auth/widgets/phone_entry_form.dart';

/// Registration step 1: phone → OTP. The form is the shared
/// PhoneEntryForm — identical to forgot-password except strings,
/// purpose (set on the cubit by the route), and the bottom nav row.
class RegisterPhoneScreen extends StatelessWidget {
  const RegisterPhoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;

    return AuthFlowScaffold(
      title: l10n.authRegisterTitle,
      description: l10n.authRegisterDescription,
      child: Column(
        children: [
          PhoneEntryForm(buttonLabel: l10n.authRequestOtpButton),
          const SizedBox(height: 24),
          const OrDivider(),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${l10n.authAlreadyHaveAccount} ',
                style: TextStyle(color: colors.textSecondary),
              ),
              TextButton(
                onPressed: () => context.canPop()
                    ? context.pop()
                    : context.go(AppRoutePath.signIn),
                child: Text(
                  l10n.authSignInNow,
                  style: TextStyle(
                    color: colors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
