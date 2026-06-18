import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/widgets/app_primary_button.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_text_field.dart';
import '../widgets/auth_flow_scaffold.dart';
import '../cubit/reset_password_cubit.dart';
import '../cubit/reset_password_state.dart';

/// Password reset step 3: choose a new password, then back to sign-in.
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      context.read<ResetPasswordCubit>().submit(
        password: _passwordController.text,
        passwordConfirmation: _confirmController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<ResetPasswordCubit, ResetPasswordState>(
      listener: (context, state) {
        switch (state) {
          case ResetPasswordSuccess():
            AppSnackbar.success(l10n.passwordResetSuccess);
            context.go(AppRoutePath.signIn);
          case ResetPasswordFailure(
            :final serverMessage,
            :final isNetworkError,
          ):
            AppSnackbar.error(
              isNetworkError
                  ? l10n.errorNoInternet
                  : serverMessage ?? l10n.passwordResetFailed,
            );
          default:
            break;
        }
      },
      child: AuthFlowScaffold(
        title: l10n.resetPasswordTitle,
        description: l10n.resetPasswordDesc,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              PasswordField(
                controller: _passwordController,
                label: l10n.newPassword,
                hint: l10n.inputPassword,
                textInputAction: TextInputAction.next,
                validator: (v) => Validators.password(
                  v,
                  required: l10n.inputPasswordMsg,
                  tooShort: l10n.passwordTooShort,
                ),
              ),
              const SizedBox(height: 20),
              PasswordField(
                controller: _confirmController,
                label: l10n.confirmPassword,
                hint: l10n.inputConfirmPassword,
                validator: (v) => Validators.confirmPassword(
                  v,
                  _passwordController.text,
                  required: l10n.inputPasswordMsg,
                  mismatch: l10n.passwordMismatch,
                ),
              ),
              const SizedBox(height: 28),
              BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
                builder: (context, state) => AppPrimaryButton(
                  label: l10n.resetPasswordTitle,
                  isLoading: state is ResetPasswordLoading,
                  onPressed: _submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
