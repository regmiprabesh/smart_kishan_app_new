import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/utils/app_snackbar.dart';
import 'package:smart_kishan/core/utils/formatters.dart';
import 'package:smart_kishan/core/widgets/app_bar.dart';

import '../cubit/request_cancel_cubit.dart';
import '../cubit/request_cancel_state.dart';
import '../data/subsidy_request.dart';
import '../data/subsidy_labels.dart';
import '../widgets/application_status.dart';
import '../widgets/application_timeline.dart';
import '../widgets/subsidy_section_header.dart';
import 'request_detail_args.dart';

class RequestDetailScreen extends StatelessWidget {
  const RequestDetailScreen({super.key, required this.args});

  final RequestDetailArgs args;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final r = args.request;
    final converted = r.status?.toLowerCase() == 'converted';
    final crop = r.targetCropOrSector?.of(context) ?? '';
    final desc = r.description?.of(context) ?? '';
    final why = r.justification?.of(context) ?? '';
    final adminNotes = r.adminNotes?.of(context) ?? '';

    return Scaffold(
      appBar: AppAppBar(title: l10n.subsidyRequestDetailsTitle),
      body: BlocListener<RequestCancelCubit, RequestCancelState>(
        listener: (context, state) {
          if (state is RequestCancelled) {
            AppSnackbar.success(l10n.subsidyCancelSuccess);
            context.pop(true);
          } else if (state is RequestCancelFailure) {
            AppSnackbar.error(
              state.message.isEmpty ? l10n.errorGeneric : state.message,
            );
          }
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _Hero(status: r.status, title: r.title?.of(context) ?? ''),
            const SizedBox(height: 22),

            SubsidySectionTitle(title: l10n.subsidyApplicationTimeline),
            const SizedBox(height: 14),
            ApplicationTimeline(
              status: r.status,
              appliedAt: r.createdAt,
              reviewedAt: r.reviewedAt,
            ),

            if (converted) ...[
              const SizedBox(height: 18),
              _banner(
                context,
                Icons.published_with_changes_rounded,
                context.colors.primary,
                l10n.subsidyRequestConvertedNotice,
              ),
            ],

            const SizedBox(height: 22),
            SubsidySectionTitle(title: l10n.subsidyRequestInformation),
            const SizedBox(height: 12),
            _InfoRow(l10n.subsidyType, subsidyTypeLabel(l10n, r.subsidyType)),
            _InfoRow(
              l10n.subsidyRequestLevel,
              subsidyLevelLabel(l10n, r.requestedToLevel),
            ),
            if (r.createdAt != null)
              _InfoRow(
                l10n.subsidyRequestedOnLabel,
                context.shortDate(r.createdAt),
              ),

            if (desc.isNotEmpty) ...[
              const SizedBox(height: 14),
              SubsidySectionTitle(title: l10n.subsidyDescription),
              const SizedBox(height: 10),
              _paragraph(context, desc),
            ],
            if (crop.isNotEmpty) ...[
              const SizedBox(height: 14),
              SubsidySectionTitle(title: l10n.subsidyTargetCropSector),
              const SizedBox(height: 10),
              _paragraph(context, crop),
            ],
            if (why.isNotEmpty) ...[
              const SizedBox(height: 14),
              SubsidySectionTitle(title: l10n.subsidyJustification),
              const SizedBox(height: 10),
              _paragraph(context, why),
            ],
            if (adminNotes.isNotEmpty) ...[
              const SizedBox(height: 14),
              SubsidySectionTitle(title: l10n.subsidyAdminNotes),
              const SizedBox(height: 10),
              _banner(
                context,
                Icons.sticky_note_2_outlined,
                r.status?.toLowerCase() == 'rejected'
                    ? context.colors.error
                    : context.colors.info,
                adminNotes,
              ),
            ],

            if (canCancelRequest(r.status)) ...[
              const SizedBox(height: 26),
              _CancelButton(requestId: r.id!),
            ],
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _paragraph(BuildContext context, String text) {
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
        text,
        style: TextStyle(
          fontSize: 14,
          height: 1.45,
          color: colors.textSecondary,
        ),
      ),
    );
  }

  Widget _banner(BuildContext context, IconData icon, Color c, String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: c),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: context.colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.status, required this.title});
  final String? status;
  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context)!;
    final c = applicationStatusColor(context, status);
    return Container(
      padding: const EdgeInsets.all(18),
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
            width: 52,
            height: 52,
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
                  title.isEmpty ? l10n.subsidyUntitled : title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                StatusBadge(status: status),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CancelButton extends StatelessWidget {
  const _CancelButton({required this.requestId});
  final int requestId;

  Future<void> _confirm(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.subsidyCancelConfirmTitle),
        content: Text(l10n.subsidyCancelConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: colors.error),
            child: Text(l10n.subsidyCancelRequest),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      context.read<RequestCancelCubit>().cancel(requestId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<RequestCancelCubit, RequestCancelState>(
      builder: (context, state) {
        final busy = state is RequestCancelling;
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
                : Icon(Icons.delete_outline, color: colors.error),
            label: Text(
              l10n.subsidyCancelRequest,
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
