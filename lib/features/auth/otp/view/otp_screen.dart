import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_kishan/app/router/app_routes.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/services/sms_autofill_service.dart';
import 'package:smart_kishan/core/utils/app_snackbar.dart';
import 'package:smart_kishan/core/utils/formatters.dart';
import 'package:smart_kishan/core/widgets/app_primary_button.dart';
import 'package:smart_kishan/features/auth/data/auth_flow_args.dart';
import 'package:smart_kishan/features/auth/data/otp_purpose.dart';
import 'package:smart_kishan/features/auth/otp/cubit/otp_cubit.dart';
import 'package:smart_kishan/features/auth/otp/cubit/otp_state.dart';
import 'package:smart_kishan/features/auth/otp/widgets/otp_input.dart';
import 'package:smart_kishan/features/auth/widgets/auth_flow_scaffold.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _codeController = TextEditingController();
  final _smsAutofill = SmsAutofillService();

  @override
  void initState() {
    super.initState();
    _listenForSms();
  }

  Future<void> _listenForSms() async {
    final code = await _smsAutofill.listenForCode();
    if (code != null && mounted) {
      _codeController.text = code; // fills the pinput boxes
      _verify();
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _smsAutofill.dispose();
    super.dispose();
  }

  void _verify() {
    FocusScope.of(context).unfocus();
    if (_codeController.text.length < 6) return;
    context.read<OtpCubit>().verify(_codeController.text);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final args = context.read<OtpCubit>().args;

    return BlocListener<OtpCubit, OtpState>(
      listenWhen: (prev, curr) =>
          prev.status != curr.status || prev.tick != curr.tick,
      listener: (context, state) {
        switch (state.status) {
          case OtpStatus.verified:
            final next = args.purpose == OtpPurpose.registration
                ? AppRoutePath.registerDetails
                : AppRoutePath.resetPassword;
            context.pushReplacement(
              next,
              extra: VerifiedFlowArgs(
                phone: args.phone,
                verificationToken: state.verificationToken,
              ),
            );
          case OtpStatus.invalid:
            AppSnackbar.error(l10n.authOtpInvalid);
          case OtpStatus.expired:
            AppSnackbar.error(l10n.authOtpExpired);
          case OtpStatus.noCode:
            AppSnackbar.error(l10n.authOtpInvalid);
          case OtpStatus.tooManyAttempts:
            AppSnackbar.error(l10n.authOtpTooManyAttempts);
          case OtpStatus.resent:
            AppSnackbar.success(l10n.authOtpResent);
          case OtpStatus.resendFailed:
            AppSnackbar.error(l10n.authOtpSendFailed);
          case OtpStatus.throttled:
            AppSnackbar.error(
              l10n.authOtpThrottled(context.ld(state.retryAfterSeconds ?? 60)),
            );
          case OtpStatus.network:
            AppSnackbar.error(l10n.errorNoInternet);
          default:
            break;
        }
      },
      child: AuthFlowScaffold(
        title: l10n.authOtpTitle,
        description: l10n.authOtpDescription('+977 ${args.phone}'),
        child: Column(
          children: [
            OtpInput(
              controller: _codeController,
              onCompleted: (_) => _verify(),
            ),
            const SizedBox(height: 28),
            BlocBuilder<OtpCubit, OtpState>(
              buildWhen: (p, c) => p.status != c.status,
              builder: (context, state) => AppPrimaryButton(
                label: l10n.authVerifyButton,
                isLoading: state.status == OtpStatus.verifying,
                onPressed: _verify,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.authDidNotReceiveOtp,
                  style: TextStyle(fontSize: 13, color: colors.textSecondary),
                ),
                BlocBuilder<OtpCubit, OtpState>(
                  buildWhen: (p, c) =>
                      p.secondsLeft != c.secondsLeft || p.status != c.status,
                  builder: (context, state) => TextButton(
                    onPressed: state.canResend
                        ? () => context.read<OtpCubit>().resend()
                        : null,
                    child: Text(
                      state.secondsLeft > 0
                          ? l10n.authResendInSeconds(
                              context.ld(state.secondsLeft),
                            )
                          : l10n.authResendButton,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: state.canResend
                            ? colors.primary
                            : colors.textHint,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
