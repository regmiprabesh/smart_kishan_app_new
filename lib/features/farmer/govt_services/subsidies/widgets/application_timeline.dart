import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/utils/formatters.dart';
import 'package:smart_kishan/features/farmer/govt_services/subsidies/data/subsidy_labels.dart';

import 'application_status.dart';

/// Vertical timeline: Submitted → Under review → Decision. Steps light up by
/// the application status; the decision step resolves to approved/rejected.
class ApplicationTimeline extends StatelessWidget {
  const ApplicationTimeline({
    super.key,
    required this.status,
    this.appliedAt,
    this.reviewedAt,
  });

  final String? status;
  final String? appliedAt;
  final String? reviewedAt;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final s = status?.toLowerCase();
    final reviewed = s == 'under_review' || s == 'approved' || s == 'rejected';
    final decided = s == 'approved' || s == 'rejected';

    final steps = <_Step>[
      _Step(
        title: l10n.subsidyTimelineSubmitted,
        subtitle: appliedAt != null ? context.shortDate(appliedAt) : null,
        done: true,
        color: colors.success,
        icon: Icons.send_rounded,
      ),
      _Step(
        title: l10n.subsidyTimelineUnderReview,
        subtitle: reviewed ? null : l10n.subsidyTimelinePendingReview,
        done: reviewed,
        active: s == 'under_review',
        color: colors.info,
        icon: Icons.fact_check_outlined,
      ),
      _Step(
        title: decided
            ? subsidyStatusLabel(l10n, status)
            : l10n.subsidyTimelineAwaitingDecision,
        subtitle: decided && reviewedAt != null
            ? context.shortDate(reviewedAt)
            : null,
        done: decided,
        color: decided
            ? applicationStatusColor(context, status)
            : colors.textHint,
        icon: decided ? applicationStatusIcon(status) : Icons.flag_outlined,
      ),
    ];

    return Column(
      children: [
        for (var i = 0; i < steps.length; i++)
          _StepRow(step: steps[i], isLast: i == steps.length - 1),
      ],
    );
  }
}

class _Step {
  _Step({
    required this.title,
    this.subtitle,
    required this.done,
    this.active = false,
    required this.color,
    required this.icon,
  });
  final String title;
  final String? subtitle;
  final bool done;
  final bool active;
  final Color color;
  final IconData icon;
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.step, required this.isLast});
  final _Step step;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final reached = step.done || step.active;
    final dotColor = reached ? step.color : colors.border;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: reached
                      ? step.color.withValues(alpha: 0.15)
                      : colors.surfaceAlt,
                  shape: BoxShape.circle,
                  border: Border.all(color: dotColor, width: 2),
                ),
                child: Icon(step.icon, size: 18, color: dotColor),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: step.done ? step.color : colors.border,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 6, bottom: isLast ? 0 : 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: reached ? colors.textPrimary : colors.textHint,
                    ),
                  ),
                  if (step.subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      step.subtitle!,
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
