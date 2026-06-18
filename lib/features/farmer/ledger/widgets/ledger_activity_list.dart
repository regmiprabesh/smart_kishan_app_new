import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/utils/formatters.dart';
import 'package:smart_kishan/core/widgets/app_empty_state.dart';
import 'package:smart_kishan/features/farmer/daily_activity/data/activity.dart';

/// What each row should display as its amount.
enum LedgerAmount { income, expense, auto }

/// A single card holding a titled list of ledger entries.
class LedgerActivityList extends StatelessWidget {
  const LedgerActivityList({
    super.key,
    required this.title,
    required this.activities,
    required this.amountMode,
    required this.emptyTitle,
  });

  final String title;
  final List<Activity> activities;
  final LedgerAmount amountMode;
  final String emptyTitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Container(
                  height: 20,
                  width: 4,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (activities.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: AppEmptyState(
                icon: Icons.receipt_long_outlined,
                title: emptyTitle,
                compact: true,
              ),
            )
          else
            ...List.generate(activities.length, (i) {
              final a = activities[i];
              return Column(
                children: [
                  if (i > 0)
                    Divider(
                      height: 1,
                      color: colors.divider,
                      indent: 16,
                      endIndent: 16,
                    ),
                  _Row(activity: a, amountMode: amountMode),
                ],
              );
            }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.activity, required this.amountMode});
  final Activity activity;
  final LedgerAmount amountMode;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context)!;

    final bool hasBoth =
        amountMode == LedgerAmount.auto &&
        activity.income != null &&
        activity.expense != null;

    final bool showIncome =
        hasBoth ||
        switch (amountMode) {
          LedgerAmount.income => true,
          LedgerAmount.expense => false,
          LedgerAmount.auto => activity.income != null,
        };

    final Color iconColor = showIncome ? colors.success : colors.error;
    final IconData icon = showIncome
        ? Icons.arrow_downward
        : Icons.arrow_upward;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          if (hasBoth)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colors.success.withValues(alpha: 0.15),
                    colors.error.withValues(alpha: 0.15),
                  ],
                ),
              ),
              child: ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) => LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [colors.success, colors.error],
                ).createShader(bounds),
                child: const Icon(
                  Icons.swap_vert,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 16),
            ),
          const SizedBox(width: 12),
          // Shared title + date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  context.shortDate(activity.date),
                  style: TextStyle(fontSize: 11, color: colors.textSecondary),
                ),
              ],
            ),
          ),
          // Trailing: stacked for dual, single text otherwise
          if (hasBoth)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '+${l10n.currencySymbol} ${context.ld(activity.income!.toStringAsFixed(0))}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: colors.success,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '-${l10n.currencySymbol} ${context.ld(activity.expense!.toStringAsFixed(0))}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: colors.error,
                  ),
                ),
              ],
            )
          else
            Text(
              '${showIncome ? '+' : '-'}${l10n.currencySymbol} ${context.ld(((showIncome ? activity.income : activity.expense) ?? 0).toStringAsFixed(0))}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: showIncome ? colors.success : colors.error,
              ),
            ),
        ],
      ),
    );
  }
}
