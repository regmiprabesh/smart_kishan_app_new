import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_kishan/app/router/app_routes.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/utils/app_snackbar.dart';
import 'package:smart_kishan/core/utils/formatters.dart';
import 'package:smart_kishan/core/utils/validators.dart';
import 'package:smart_kishan/core/widgets/app_text_field.dart';
import 'package:smart_kishan/core/widgets/app_primary_button.dart';
import 'package:smart_kishan/features/auth/data/auth_flow_args.dart';
import 'package:smart_kishan/features/auth/cubit/phone_entry_cubit.dart';
import 'package:smart_kishan/features/auth/cubit/phone_entry_state.dart';

/// Phone field + submit button + error handling for "send me an OTP".
/// Used by RegisterPhoneScreen AND ForgotPasswordPhoneScreen (shared sub-flow) — the cubit's
/// purpose decides the backend behavior; success always goes to /otp.
class PhoneEntryForm extends StatefulWidget {
  const PhoneEntryForm({super.key, required this.buttonLabel});

  final String buttonLabel;

  @override
  State<PhoneEntryForm> createState() => _PhoneEntryFormState();
}

class _PhoneEntryFormState extends State<PhoneEntryForm> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      context.read<PhoneEntryCubit>().submit(_phoneController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<PhoneEntryCubit, PhoneEntryState>(
      listener: (context, state) {
        switch (state) {
          case PhoneEntrySuccess(:final phone):
            AppSnackbar.success(l10n.authOtpSent);
            context.push(
              AppRoutePath.otp,
              extra: OtpFlowArgs(
                phone: phone,
                purpose: context.read<PhoneEntryCubit>().purpose,
              ),
            );
          case PhoneEntryFailure(:final error, :final retryAfterSeconds):
            AppSnackbar.error(switch (error) {
              OtpSendError.alreadyRegistered => l10n.authPhoneAlreadyRegistered,
              OtpSendError.notRegistered => l10n.authPhoneNotRegistered,
              OtpSendError.throttled => l10n.authOtpThrottled(
                context.ld(retryAfterSeconds ?? 60),
              ),
              OtpSendError.network => l10n.errorNoInternet,
              OtpSendError.generic => l10n.authOtpSendFailed,
            });
          default:
            break;
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            PhoneField(
              controller: _phoneController,
              label: l10n.phoneNumber,
              hint: l10n.phoneNumberHint,
              validator: (v) => Validators.phone(
                v,
                required: l10n.phoneNumberRequired,
                invalid: l10n.phoneNumberInvalid,
              ),
            ),
            const SizedBox(height: 28),
            BlocBuilder<PhoneEntryCubit, PhoneEntryState>(
              builder: (context, state) => AppPrimaryButton(
                label: widget.buttonLabel,
                isLoading: state is PhoneEntryLoading,
                onPressed: _submit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
