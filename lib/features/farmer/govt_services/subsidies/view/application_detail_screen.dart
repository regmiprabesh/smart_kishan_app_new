import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/utils/app_snackbar.dart';
import 'package:smart_kishan/core/utils/formatters.dart';
import 'package:smart_kishan/core/widgets/app_bar.dart';

import '../cubit/application_withdraw_cubit.dart';
import '../cubit/application_withdraw_state.dart';
import '../data/application_form_field.dart';
import '../data/subsidy.dart';
import '../data/subsidy_document.dart';
import '../data/subsidy_labels.dart';
import '../widgets/application_status.dart';
import '../widgets/application_timeline.dart';
import '../widgets/subsidy_document_tile.dart';
import '../widgets/subsidy_section_header.dart';
import 'application_detail_args.dart';

class ApplicationDetailScreen extends StatelessWidget {
  const ApplicationDetailScreen({super.key, required this.args});

  final ApplicationDetailArgs args;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final s = args.subsidy;
    final app = s.application;
    final formEntries = _formEntries(context, s);
    final docs = _documents(app?.documents);

    return Scaffold(
      appBar: AppAppBar(title: l10n.subsidyApplicationDetailsTitle),
      body: BlocListener<ApplicationWithdrawCubit, ApplicationWithdrawState>(
        listener: (context, state) {
          if (state is ApplicationWithdrawn) {
            AppSnackbar.success(l10n.subsidyWithdrawSuccess);
            context.pop(true);
          } else if (state is ApplicationWithdrawFailure) {
            AppSnackbar.error(
              state.message.isEmpty ? l10n.errorGeneric : state.message,
            );
          }
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _StatusHero(status: app?.status, appliedAt: app?.appliedAt),
            const SizedBox(height: 22),

            SubsidySectionTitle(title: l10n.subsidyApplicationTimeline),
            const SizedBox(height: 14),
            ApplicationTimeline(
              status: app?.status,
              appliedAt: app?.appliedAt,
              reviewedAt: app?.reviewedAt,
            ),
            const SizedBox(height: 22),

            SubsidySectionTitle(title: l10n.subsidyDetails),
            const SizedBox(height: 10),
            _subsidySummary(context, l10n, s),

            if ((app?.notes ?? '').isNotEmpty) ...[
              const SizedBox(height: 22),
              SubsidySectionTitle(title: l10n.subsidyApplicationNotes),
              const SizedBox(height: 10),
              _noteCard(context, app!.notes!),
            ],

            if (formEntries.isNotEmpty) ...[
              const SizedBox(height: 22),
              SubsidySectionTitle(title: l10n.subsidySubmittedDetails),
              const SizedBox(height: 12),
              ...formEntries.map((e) => _InfoRow(e.key, e.value)),
            ],

            if (docs.isNotEmpty) ...[
              const SizedBox(height: 22),
              SubsidySectionTitle(title: l10n.subsidySubmittedDocuments),
              const SizedBox(height: 12),
              ...docs.map((d) => AdminDocumentTile(doc: d)),
            ],

            if (canWithdraw(app?.status)) ...[
              const SizedBox(height: 26),
              _WithdrawButton(subsidyId: s.id!),
            ],
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _subsidySummary(
    BuildContext context,
    AppLocalizations l10n,
    Subsidy s,
  ) {
    final colors = context.colors;
    final title = s.title?.of(context) ?? '';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.isEmpty ? l10n.subsidyUntitled : title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _tag(
                context,
                Icons.category_outlined,
                subsidyTypeLabel(l10n, s.subsidyType),
              ),
              if (s.budgetPerBeneficiary != null)
                _tag(
                  context,
                  Icons.payments_outlined,
                  '${l10n.currencySymbol} ${context.ld(s.budgetPerBeneficiary!)}',
                ),
              if (s.locationLevel != null)
                _tag(
                  context,
                  Icons.place_outlined,
                  subsidyLevelLabel(l10n, s.locationLevel),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tag(BuildContext context, IconData icon, String text) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colors.primary),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _noteCard(BuildContext context, String notes) {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border.withValues(alpha: 0.6)),
      ),
      child: Text(
        notes,
        style: TextStyle(
          fontSize: 14,
          height: 1.4,
          color: colors.textSecondary,
        ),
      ),
    );
  }

  /// Maps stored `form_data` to readable (label, value) pairs using the
  /// subsidy's field definitions (falls back to the raw key / value).
  List<MapEntry<String, String>> _formEntries(BuildContext context, Subsidy s) {
    final data = s.application?.formData ?? const {};
    if (data.isEmpty) return const [];
    final lang = Localizations.localeOf(context).languageCode;
    final fields = {
      for (final f in s.applicationFormFields)
        if (f.fieldKey != null) f.fieldKey!: f,
    };
    final out = <MapEntry<String, String>>[];
    data.forEach((key, raw) {
      if (raw == null || raw == '' || raw == 'null') return;
      final f = fields[key];
      final label = f?.label?.of(context) ?? _prettify(key);
      out.add(MapEntry(label, _displayValue(context, f, raw, lang)));
    });
    return out;
  }

  String _displayValue(
    BuildContext context,
    ApplicationFormField? f,
    dynamic raw,
    String lang,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final v = '$raw';
    if (f?.fieldType == 'checkbox') {
      return (v == '1' || v == 'true') ? l10n.commonYes : l10n.commonNo;
    }
    if (f != null && f.options.isNotEmpty) {
      for (final o in f.options) {
        if (o.value == v) return o.labelFor(lang);
      }
    }
    return v.isEmpty ? '—' : v;
  }

  String _prettify(String key) => key
      .replaceAll('_', ' ')
      .split(' ')
      .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
      .join(' ');

  List<SubsidyDocument> _documents(List<dynamic>? raw) {
    if (raw == null) return const [];
    return raw
        .whereType<Map>()
        .map((m) => SubsidyDocument.fromJson(Map<String, dynamic>.from(m)))
        .toList();
  }
}

/// Status banner: big status icon + label, applied date — color by status.
class _StatusHero extends StatelessWidget {
  const _StatusHero({required this.status, this.appliedAt});

  final String? status;
  final String? appliedAt;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context)!;
    final c = applicationStatusColor(context, status);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [c.withValues(alpha: 0.16), c.withValues(alpha: 0.06)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(color: c, shape: BoxShape.circle),
            child: Icon(
              applicationStatusIcon(status),
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subsidyStatusLabel(l10n, status),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: c,
                  ),
                ),
                if (appliedAt != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    l10n.subsidyAppliedOn(context.shortDate(appliedAt)),
                    style: TextStyle(fontSize: 13, color: colors.textSecondary),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WithdrawButton extends StatelessWidget {
  const _WithdrawButton({required this.subsidyId});

  final int subsidyId;

  Future<void> _confirm(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.subsidyWithdrawConfirmTitle),
        content: Text(l10n.subsidyWithdrawConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: colors.error),
            child: Text(l10n.subsidyWithdraw),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      context.read<ApplicationWithdrawCubit>().withdraw(subsidyId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<ApplicationWithdrawCubit, ApplicationWithdrawState>(
      builder: (context, state) {
        final busy = state is ApplicationWithdrawing;
        return SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            onPressed: busy ? null : () => _confirm(context),
            icon: busy
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colors.error,
                    ),
                  )
                : Icon(Icons.cancel_outlined, color: colors.error),
            label: Text(
              l10n.subsidyWithdraw,
              style: TextStyle(
                color: colors.error,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: colors.error),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
          ),
          const Text(': ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(fontSize: 14, color: colors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
