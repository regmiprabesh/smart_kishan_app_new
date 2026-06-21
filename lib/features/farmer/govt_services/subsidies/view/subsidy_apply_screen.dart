import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_kishan/app/router/app_routes.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/utils/app_snackbar.dart';
import 'package:smart_kishan/core/widgets/app_bar.dart';
import 'package:smart_kishan/core/widgets/app_image_preview.dart';
import 'package:smart_kishan/core/widgets/app_pdf_preview.dart';
import 'package:smart_kishan/core/widgets/app_media_picker.dart';
import 'package:smart_kishan/core/widgets/app_primary_button.dart';
import 'package:smart_kishan/core/widgets/app_text_field.dart';
import 'package:smart_kishan/features/auth/cubit/session_cubit.dart';
import 'package:smart_kishan/features/auth/cubit/session_state.dart';
import 'package:smart_kishan/features/farmer/govt_services/subsidies/widgets/subsidy_section_header.dart';
import 'package:smart_kishan/shared/models/user.dart';

import '../cubit/subsidy_apply_cubit.dart';
import '../cubit/subsidy_apply_state.dart';
import '../data/application_form_field.dart';
import '../data/subsidy.dart';
import '../data/subsidy_document.dart';
import '../data/subsidy_repository.dart';
import '../subsidy_labels.dart';
import '../widgets/subsidy_document_upload.dart';
import '../widgets/subsidy_form_field.dart';

class SubsidyApplyScreen extends StatefulWidget {
  const SubsidyApplyScreen({super.key, required this.subsidy});

  final Subsidy subsidy;

  @override
  State<SubsidyApplyScreen> createState() => _SubsidyApplyScreenState();
}

class _SubsidyApplyScreenState extends State<SubsidyApplyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controllers = <String, TextEditingController>{};
  final _values = <String, dynamic>{};
  final _uploads = <int, PickedMedia>{}; // required-doc index -> picked file
  final _notes = TextEditingController();
  bool _attempted = false;

  Subsidy get _subsidy => widget.subsidy;

  @override
  void initState() {
    super.initState();
    _initFields();
  }

  User? get _user {
    final s = context.read<SessionCubit>().state;
    return s is Authenticated ? s.user : null;
  }

  bool _needsController(String? t) =>
      const ['text', 'number', 'email', 'phone', 'textarea'].contains(t);

  void _initFields() {
    final user = _user;
    for (final f in _subsidy.applicationFormFields) {
      final key = f.fieldKey;
      if (key == null) continue;
      if (_needsController(f.fieldType)) {
        _controllers[key] = TextEditingController();
      }
      if (f.isPrefilled && f.prefillSource != null && user != null) {
        final v = _prefillValue(user, f.prefillSource!);
        if (v == null || v.isEmpty) continue;
        if (_controllers.containsKey(key)) {
          _controllers[key]!.text = v;
        } else {
          // dropdown / radio prefill: match an option by value or English label
          final match = f.options.firstWhere(
            (o) => o.value == v || o.labelEn == v,
            orElse: () => const FieldOption(),
          );
          _values[key] = match.value ?? v;
        }
      }
    }
  }

  String? _prefillValue(User u, String source) {
    switch (source) {
      case 'full_name':
        return u.fullName;
      case 'email':
        return u.emailAddress;
      case 'phone':
        return u.phoneNumber;
      case 'province':
        return u.province?.name?.get('en');
      case 'district':
        return u.district?.name?.get('en');
      case 'municipality':
        return u.municipality?.name?.get('en');
      case 'ward':
        return u.ward?.name?.get('en');
      case 'address':
        return u.fullAddress ?? u.address;
      default:
        return null;
    }
  }

  @override
  void dispose() {
    _notes.dispose();
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDocument(int index, RequiredDocument doc) async {
    final l10n = AppLocalizations.of(context)!;
    final media = await AppMediaPicker.pick(
      context,
      allowImagesOnly: false,
      allowedExtensions: doc.acceptedFormats,
    );
    if (media == null) return;
    final ext = (media.name ?? media.path).split('.').last.toLowerCase();
    if (!doc.acceptedFormats.map((e) => e.toLowerCase()).contains(ext)) {
      AppSnackbar.error(l10n.subsidyInvalidFileType);
      return;
    }
    final bytes = await File(media.path).length();
    if (bytes > doc.maxFileSize * 1024 * 1024) {
      AppSnackbar.error(l10n.subsidyFileTooLarge);
      return;
    }
    setState(() => _uploads[index] = media);
  }

  bool _isPdf(PickedMedia m) =>
      (m.name ?? m.path).toLowerCase().endsWith('.pdf');

  void _preview(int index) {
    final media = _uploads[index];
    if (media == null) return;
    if (media.isImage) {
      AppImagePreview.open(context, imageUrls: [media.path]);
    } else if (_isPdf(media)) {
      AppPdfPreview.open(context, media.path, title: media.name);
    } else {
      AppSnackbar.info(AppLocalizations.of(context)!.subsidyPreviewUnavailable);
    }
  }

  void _submit() {
    final l10n = AppLocalizations.of(context)!;
    FocusScope.of(context).unfocus();
    setState(() => _attempted = true);

    final formValid = _formKey.currentState?.validate() ?? false;
    final docsMissing = _subsidy.requiredDocuments.asMap().entries.any(
      (e) => e.value.isRequired && !_uploads.containsKey(e.key),
    );

    if (!formValid || docsMissing) {
      if (docsMissing) AppSnackbar.error(l10n.subsidyDocumentMissing);
      return;
    }

    final formData = <String, String>{};
    _controllers.forEach((k, c) => formData[k] = c.text.trim());
    _values.forEach((k, v) {
      formData[k] = v is bool ? (v ? '1' : '0') : '${v ?? ''}';
    });

    final docs = _uploads.entries.map((e) {
      final docType = _subsidy.requiredDocuments[e.key].name?.get('en') ?? '';
      return ApplyDocument(documentType: docType, filePath: e.value.path);
    }).toList();

    context.read<SubsidyApplyCubit>().submit(
      subsidyId: _subsidy.id!,
      notes: _notes.text.trim(),
      formData: formData,
      documents: docs,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<SubsidyApplyCubit, SubsidyApplyState>(
      listener: (context, state) {
        if (state is SubsidyApplySuccess) {
          AppSnackbar.success(l10n.subsidyApplicationSuccess);
          context.go(AppRoutePath.subsidies);
        } else if (state is SubsidyApplyFailure) {
          AppSnackbar.error(
            state.message.isEmpty ? l10n.errorGeneric : state.message,
          );
        }
      },
      builder: (context, state) {
        final submitting = state is SubsidyApplySubmitting;
        return Scaffold(
          appBar: AppAppBar(title: l10n.subsidyApplyTitle),
          body: AbsorbPointer(
            absorbing: submitting,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _infoCard(context, l10n),
                    const SizedBox(height: 20),
                    if (_subsidy.applicationFormFields.isNotEmpty) ...[
                      SubsidySectionTitle(
                        title: l10n.subsidyApplicationDetails,
                      ),
                      const SizedBox(height: 10),
                      ..._subsidy.applicationFormFields.map(_buildField),
                    ],
                    if (_subsidy.requiredDocuments.isNotEmpty) ...[
                      SubsidySectionTitle(title: l10n.subsidyRequiredDocuments),
                      const SizedBox(height: 10),
                      ..._subsidy.requiredDocuments.asMap().entries.map((e) {
                        final media = _uploads[e.key];
                        return SubsidyDocumentUpload(
                          doc: e.value,
                          fileName: media?.name ?? media?.path.split('/').last,
                          onPick: () => _pickDocument(e.key, e.value),
                          onRemove: () =>
                              setState(() => _uploads.remove(e.key)),
                          onPreview: () => _preview(e.key),
                          showError: _attempted,
                        );
                      }),
                      const SizedBox(height: 8),
                    ],
                    AppTextField(
                      controller: _notes,
                      label: l10n.subsidyApplicationNotes,
                      hint: l10n.subsidyApplicationNotesHint,
                      maxLines: 4,
                      textInputAction: TextInputAction.newline,
                    ),
                    const SizedBox(height: 20),
                    _reviewNotice(context, l10n),
                    const SizedBox(height: 16),
                    AppPrimaryButton(
                      label: l10n.subsidySubmitApplication,
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

  Widget _buildField(ApplicationFormField f) {
    final key = f.fieldKey;
    return SubsidyFormField(
      field: f,
      controller: key == null ? null : _controllers[key],
      value: key == null ? null : _values[key],
      onChanged: key == null ? null : (v) => setState(() => _values[key] = v),
    );
  }

  Widget _reviewNotice(BuildContext context, AppLocalizations l10n) {
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
          Icon(Icons.info_outline, size: 20, color: colors.info),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n.subsidyApplyReviewNotice,
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(BuildContext context, AppLocalizations l10n) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.subsidyApplyingFor,
            style: TextStyle(fontSize: 12, color: colors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            _subsidy.title?.of(context) ?? l10n.subsidyUntitled,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subsidyTypeLabel(l10n, _subsidy.subsidyType),
            style: TextStyle(fontSize: 13, color: colors.primary),
          ),
        ],
      ),
    );
  }
}
