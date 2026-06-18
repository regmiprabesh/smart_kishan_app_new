import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_kishan/app/router/app_routes.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/utils/app_snackbar.dart';
import 'package:smart_kishan/core/utils/validators.dart';
import 'package:smart_kishan/core/widgets/app_text_field.dart';
import 'package:smart_kishan/core/widgets/app_primary_button.dart';
import 'package:smart_kishan/features/auth/widgets/auth_flow_scaffold.dart';
import 'package:smart_kishan/features/auth/widgets/or_divider.dart';
import 'sign_in_cubit.dart';
import 'sign_in_state.dart';

/// Sign-in. Pure UI — logic in SignInCubit; on success SessionCubit emits
/// Authenticated and the router redirects, so this screen does nothing.
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      context.read<SignInCubit>().submit(
        phone: _phoneController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;

    return BlocListener<SignInCubit, SignInState>(
      listener: (context, state) {
        if (state is SignInFailure) {
          AppSnackbar.error(switch (state.reason) {
            SignInError.invalidCredentials => l10n.authInvalidCredentials,
            SignInError.network => l10n.errorNoInternet,
            SignInError.generic => l10n.errorGeneric,
          });
        }
      },
      child: AuthFlowScaffold(
        title: l10n.authWelcomeBack,
        description: l10n.authLoginDescription,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(height: 20),
              PasswordField(
                controller: _passwordController,
                label: l10n.password,
                hint: l10n.passwordHint,
                validator: (v) => Validators.required(v, l10n.passwordRequired),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () =>
                      context.push(AppRoutePath.forgotPasswordPhone),
                  child: Text(
                    l10n.authForgotPassword,
                    style: TextStyle(
                      color: colors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              BlocBuilder<SignInCubit, SignInState>(
                builder: (context, state) => AppPrimaryButton(
                  label: l10n.authLoginButton,
                  isLoading: state is SignInLoading,
                  onPressed: _submit,
                ),
              ),
              const SizedBox(height: 24),
              const OrDivider(),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${l10n.authNoAccount} ',
                    style: TextStyle(color: colors.textSecondary),
                  ),
                  TextButton(
                    onPressed: () => context.push(AppRoutePath.registerPhone),
                    child: Text(
                      l10n.authRegisterNow,
                      style: TextStyle(
                        color: colors.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
