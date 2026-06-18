import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/utils/app_snackbar.dart';
import 'package:smart_kishan/core/utils/validators.dart';
import 'package:smart_kishan/core/widgets/app_text_field.dart';
import 'package:smart_kishan/core/widgets/app_primary_button.dart';
import 'package:smart_kishan/features/auth/cubit/session_cubit.dart';
import 'package:smart_kishan/features/auth/cubit/session_state.dart';
import 'package:smart_kishan/features/profile/cubit/edit_profile_cubit.dart';
import 'package:smart_kishan/features/profile/cubit/edit_profile_state.dart';

/// Edit name / email / phone. Pre-filled from the current session user.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _phone;

  @override
  void initState() {
    super.initState();
    final s = context.read<SessionCubit>().state;
    final user = s is Authenticated ? s.user : null;
    _name = TextEditingController(text: user?.name ?? '');
    _email = TextEditingController(text: user?.email ?? '');
    _phone = TextEditingController(text: user?.phone ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _save() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      context.read<EditProfileCubit>().save(
        name: _name.text.trim(),
        email: _email.text.trim(),
        phone: _phone.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<EditProfileCubit, EditProfileState>(
      listener: (context, state) {
        switch (state) {
          case EditProfileSaved():
            AppSnackbar.success(l10n.profileUpdatedSuccessfully);
            context.pop();
          case EditProfileFailure(:final error):
            AppSnackbar.error(switch (error) {
              EditProfileError.network => l10n.errorNoInternet,
              EditProfileError.validation => l10n.profileUpdateFailed,
              EditProfileError.generic => l10n.errorGeneric,
            });
          default:
            break;
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.profile)),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                AppTextField(
                  controller: _name,
                  label: l10n.fullNameLabel,
                  prefixIcon: const Icon(Icons.person_outline),
                  validator: (v) => Validators.name(
                    v,
                    required: l10n.fullNameRequired,
                    tooShort: l10n.fullNameInvalid,
                  ),
                ),
                const SizedBox(height: 20),
                AppTextField(
                  controller: _email,
                  label: l10n.emailLabel,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined),
                  validator: (v) =>
                      Validators.emailOptional(v, invalid: l10n.emailInvalid),
                ),
                const SizedBox(height: 20),
                AppTextField(
                  controller: _phone,
                  label: l10n.phoneNumber,
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(Icons.phone_outlined),
                  validator: (v) => Validators.phone(
                    v,
                    required: l10n.phoneNumberRequired,
                    invalid: l10n.phoneNumberInvalid,
                  ),
                ),
                const SizedBox(height: 28),
                BlocBuilder<EditProfileCubit, EditProfileState>(
                  builder: (context, state) => AppPrimaryButton(
                    label: l10n.profileUpdate,
                    isLoading: state is EditProfileSaving,
                    onPressed: _save,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
