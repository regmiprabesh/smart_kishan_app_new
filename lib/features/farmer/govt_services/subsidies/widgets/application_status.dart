import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';

import '../data/subsidy_labels.dart';

/// Status → theme color. pending=warning, under_review=info,
/// approved=success, rejected=error.
Color applicationStatusColor(BuildContext context, String? status) {
  final colors = context.colors;
  switch (status?.toLowerCase()) {
    case 'approved':
      return colors.success;
    case 'rejected':
      return colors.error;
    case 'under_review':
      return colors.info;
    case 'converted':
      return colors.primary;
    case 'pending':
    default:
      return colors.warning;
  }
}

IconData applicationStatusIcon(String? status) {
  switch (status?.toLowerCase()) {
    case 'approved':
      return Icons.check_circle_rounded;
    case 'rejected':
      return Icons.cancel_rounded;
    case 'under_review':
      return Icons.fact_check_outlined;
    case 'converted':
      return Icons.published_with_changes_rounded;
    case 'pending':
    default:
      return Icons.schedule_rounded;
  }
}

/// Only open applications can be withdrawn.
bool canWithdraw(String? status) {
  final s = status?.toLowerCase();
  return s == 'pending' || s == 'under_review';
}

/// A subsidy request can be cancelled only while still pending.
bool canCancelRequest(String? status) => status?.toLowerCase() == 'pending';

/// Pill: status icon + localized label, tinted by the status color.
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status, this.large = false});

  final String? status;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final c = applicationStatusColor(context, status);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large ? 14 : 10,
        vertical: large ? 8 : 5,
      ),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(applicationStatusIcon(status), size: large ? 18 : 14, color: c),
          SizedBox(width: large ? 8 : 6),
          Text(
            subsidyStatusLabel(l10n, status),
            style: TextStyle(
              color: c,
              fontSize: large ? 14 : 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
