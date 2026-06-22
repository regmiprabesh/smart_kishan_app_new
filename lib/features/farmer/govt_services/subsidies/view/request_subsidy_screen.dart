import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/utils/app_snackbar.dart';
import 'package:smart_kishan/core/widgets/app_bar.dart';
import 'package:smart_kishan/core/widgets/app_dropdown.dart';
import 'package:smart_kishan/core/widgets/app_primary_button.dart';
import 'package:smart_kishan/core/widgets/app_text_field.dart';

import '../cubit/request_subsidy_cubit.dart';
import '../cubit/request_subsidy_state.dart';
import '../subsidy_labels.dart';

class RequestSubsidyScreen extends StatefulWidget {
  const RequestSubsidyScreen({super.key});

  @override
  State<RequestSubsidyScreen> createState() => _RequestSubsidyScreenState();
}

class _RequestSubsidyScreenState extends State<RequestSubsidyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _targetCrop = TextEditingController();
  final _justification = TextEditingController();
  String? _type;
  String? _level;

  static const _types = [
    'fertilizer', 'equipment', 'training', 'irrigation', 'livestock',
    'seeds', 'insurance', 'loan', 'organic', 'general',
  ];
  static const _levels = [
    'central', 'province', 'district', 'municipality', 'ward',
  ];

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _targetCrop.dispose();
    _justification.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<RequestSubsidyCubit>().submit(
          title: _title.text.trim(),
          description: _description.text.trim(),
          subsidyType: _type!,
          justification: _justification.text.trim(),
          requestedToLevel: _level!,
          targetCropOrSector: _targetCrop.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Raw labels (validation messages use these; the field labels add ' *').
    final lblTitle = l10n.subsidyRequestFieldTitle;
    final lblType = l10n.subsidyType;
    final lblLevel = l10n.subsidyRequestLevel;
    final lblDesc = l10n.subsidyDescription;
    final lblWhy = l10n.subsidyJustification;
    final lblCrop = l10n.subsidyTargetCropSector;

    String? req(String? v, String label) =>
        (v == null || v.trim().isEmpty) ? l10n.subsidyFieldRequiredNamed(label) : null;

    return BlocConsumer<RequestSubsidyCubit, RequestSubsidyState>(
      listener: (context, state) {
        if (state is RequestSubsidySuccess) {
          AppSnackbar.success(l10n.subsidyRequestSuccess);
          context.pop(true);
        } else if (state is RequestSubsidyFailure) {
          AppSnackbar.error(
            state.message.isEmpty ? l10n.errorGeneric : state.message,
          );
        }
      },
      builder: (context, state) {
        final submitting = state is RequestSubsidySubmitting;
        return Scaffold(
          appBar: AppAppBar(title: l10n.subsidyRequestNew),
          body: AbsorbPointer(
            absorbing: submitting,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _intro(context, l10n),
                    const SizedBox(height: 20),
                    AppTextField(
                      controller: _title,
                      label: '$lblTitle *',
                      hint: l10n.subsidyPleaseEnter(lblTitle),
                      validator: (v) => req(v, lblTitle),
                    ),
                    const SizedBox(height: 16),
                    AppDropdown<String>(
                      value: _type,
                      items: _types,
                      itemLabel: (v) => subsidyTypeLabel(l10n, v),
                      label: '$lblType *',
                      hint: l10n.subsidyPleaseSelect(lblType),
                      onChanged: (v) => setState(() => _type = v),
                      validator: (v) =>
                          v == null ? l10n.subsidyFieldRequiredNamed(lblType) : null,
                    ),
                    const SizedBox(height: 16),
                    AppDropdown<String>(
                      value: _level,
                      items: _levels,
                      itemLabel: (v) => subsidyLevelLabel(l10n, v),
                      label: '$lblLevel *',
                      hint: l10n.subsidyPleaseSelect(lblLevel),
                      onChanged: (v) => setState(() => _level = v),
                      validator: (v) =>
                          v == null ? l10n.subsidyFieldRequiredNamed(lblLevel) : null,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _targetCrop,
                      label: lblCrop,
                      hint: l10n.subsidyPleaseEnter(lblCrop),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _description,
                      label: '$lblDesc *',
                      hint: l10n.subsidyPleaseEnter(lblDesc),
                      maxLines: 4,
                      textInputAction: TextInputAction.newline,
                      validator: (v) => req(v, lblDesc),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _justification,
                      label: '$lblWhy *',
                      hint: l10n.subsidyPleaseEnter(lblWhy),
                      maxLines: 4,
                      textInputAction: TextInputAction.newline,
                      validator: (v) => req(v, lblWhy),
                    ),
                    const SizedBox(height: 24),
                    AppPrimaryButton(
                      label: l10n.subsidyRequestSubmit,
                      isLoading: submitting,
                      onPressed: _submit,
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _intro(BuildContext context, AppLocalizations l10n) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.infoLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.info.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline, size: 20, color: colors.info),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n.subsidyRequestIntro,
              style: TextStyle(fontSize: 13, height: 1.4, color: colors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
