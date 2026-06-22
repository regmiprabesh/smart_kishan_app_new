import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/utils/formatters.dart';

import '../data/subsidy.dart';
import '../subsidy_labels.dart';
import 'application_status.dart';

/// My-Applications list card: a status-tinted rail, the subsidy title with a
/// status badge, category, and the applied date.
class ApplicationCard extends StatelessWidget {
  const ApplicationCard({super.key, required this.subsidy, required this.onTap});

  final Subsidy subsidy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context)!;
    final app = subsidy.application;
    final c = applicationStatusColor(context, app?.status);
    final title = subsidy.title?.of(context) ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: 5, color: c),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 14, 6, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                title.isEmpty ? l10n.subsidyUntitled : title,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: colors.textPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            StatusBadge(status: app?.status),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _meta(
                          context,
                          Icons.category_outlined,
                          subsidyTypeLabel(l10n, subsidy.subsidyType),
                        ),
                        if (app?.appliedAt != null) ...[
                          const SizedBox(height: 6),
                          _meta(
                            context,
                            Icons.event_outlined,
                            l10n.subsidyAppliedOn(context.shortDate(app!.appliedAt)),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Icon(Icons.chevron_right, color: colors.iconSecondary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _meta(BuildContext context, IconData icon, String text) {
    final colors = context.colors;
    return Row(
      children: [
        Icon(icon, size: 14, color: colors.iconSecondary),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 12, color: colors.textSecondary),
          ),
        ),
      ],
    );
  }
}
