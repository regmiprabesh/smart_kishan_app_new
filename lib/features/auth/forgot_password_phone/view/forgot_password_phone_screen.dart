import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_kishan/app/router/app_routes.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/features/auth/widgets/or_divider.dart';

import '../../widgets/phone_entry_form.dart';
import '../../widgets/auth_flow_scaffold.dart';

/// Password reset step 1: phone → OTP. Reuses PhoneEntryForm; the route
/// provides PhoneEntryCubit(purpose: passwordReset).
class ForgotPasswordPhoneScreen extends StatelessWidget {
  const ForgotPasswordPhoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;

    return AuthFlowScaffold(
      title: l10n.authForgotPasswordTitle,
      description: l10n.authForgotPasswordDescription,
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
                '${l10n.authRememberedPassword} ',
                style: TextStyle(color: colors.textSecondary),
              ),
              GestureDetector(
                onTap: () => context.canPop()
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
