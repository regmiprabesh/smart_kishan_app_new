import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/utils/app_snackbar.dart';
import 'package:smart_kishan/core/utils/validators.dart';
import 'package:smart_kishan/core/widgets/app_text_field.dart';
import 'package:smart_kishan/core/widgets/app_primary_button.dart';
import 'package:smart_kishan/features/auth/register_details/register_details_cubit.dart';
import 'package:smart_kishan/features/auth/register_details/register_details_state.dart';
import 'package:smart_kishan/features/auth/session/session_cubit.dart';
import 'package:smart_kishan/features/auth/widgets/auth_flow_scaffold.dart';

/// Registration step 3: the actual account form. On success the session
/// starts immediately (auto-login) — the router redirects to the
/// dashboard; this screen never navigates.
class RegisterDetailsScreen extends StatefulWidget {
  const RegisterDetailsScreen({super.key});

  @override
  State<RegisterDetailsScreen> createState() => _RegisterDetailsScreenState();
}

class _RegisterDetailsScreenState extends State<RegisterDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      context.read<RegisterDetailsCubit>().submit(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        passwordConfirmation: _confirmController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<RegisterDetailsCubit, RegisterDetailsState>(
      listener: (context, state) {
        switch (state) {
          case RegisterDetailsSuccess(:final user, :final mode):
            AppSnackbar.success(l10n.authAccountCreated);
            // This emit IS the navigation: router redirects to dashboard.
            context.read<SessionCubit>().signedIn(user: user, mode: mode);
          case RegisterDetailsFailure(:final reason):
            AppSnackbar.error(switch (reason) {
              RegisterError.network => l10n.errorNoInternet,
              RegisterError.emailTaken => l10n.authEmailAlreadyRegistered,
              RegisterError.phoneTaken => l10n.authPhoneAlreadyRegistered,
              RegisterError.invalidData => l10n.authInvalidRegistrationData,
              RegisterError.verificationExpired => l10n.authVerificationExpired,
              RegisterError.generic => l10n.errorGeneric,
            });
          default:
            break;
        }
      },
      child: AuthFlowScaffold(
        title: l10n.authCreateAccountTitle,
        description: l10n.authCreateAccountDescription,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AppTextField(
                controller: _nameController,
                label: l10n.fullNameLabel,
                hint: l10n.fullNameHint,
                prefixIcon: const Icon(Icons.person_outline),
                validator: (v) => Validators.name(
                  v,
                  required: l10n.fullNameRequired,
                  tooShort: l10n.fullNameInvalid,
                ),
              ),
              const SizedBox(height: 20),
              AppTextField(
                controller: _emailController,
                label: l10n.emailLabel,
                hint: l10n.emailHint,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email_outlined),
                validator: (v) =>
                    Validators.emailOptional(v, invalid: l10n.emailInvalid),
              ),
              const SizedBox(height: 20),
              PasswordField(
                controller: _passwordController,
                label: l10n.password,
                hint: l10n.passwordHint,
                textInputAction: TextInputAction.next,
                validator: (v) => Validators.password(
                  v,
                  required: l10n.passwordRequired,
                  tooShort: l10n.passwordTooShort,
                ),
              ),
              const SizedBox(height: 20),
              PasswordField(
                controller: _confirmController,
                label: l10n.confirmPasswordLabel,
                hint: l10n.confirmPasswordHint,
                validator: (v) => Validators.confirmPassword(
                  v,
                  _passwordController.text,
                  required: l10n.confirmPasswordRequired,
                  mismatch: l10n.confirmPasswordInvalid,
                ),
              ),
              const SizedBox(height: 28),
              BlocBuilder<RegisterDetailsCubit, RegisterDetailsState>(
                builder: (context, state) => AppPrimaryButton(
                  label: l10n.authCreateAccountButton,
                  isLoading: state is RegisterDetailsLoading,
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
