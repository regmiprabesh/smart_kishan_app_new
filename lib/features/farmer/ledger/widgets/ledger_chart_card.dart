import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/features/farmer/ledger/cubit/ledger_cubit.dart';
import 'package:smart_kishan/features/farmer/ledger/cubit/ledger_state.dart';
import 'package:smart_kishan/features/farmer/ledger/data/ledger_aggregator.dart';
import 'package:smart_kishan/features/farmer/ledger/widgets/ledger_line_chart.dart';
import 'package:smart_kishan/features/farmer/ledger/widgets/period_dropdown.dart';

/// Which series the card draws.
enum LedgerView { income, expense, both }

/// Chart card shared by income / expense / chart screens: titled card with the
/// period dropdown, the line chart, and a "last 7 days/…" subtitle. The title
/// is period-aware via [titleFor].
class LedgerChartCard extends StatelessWidget {
  const LedgerChartCard({
    super.key,
    required this.view,
    required this.titleFor,
  });

  final LedgerView view;

  /// Returns the card title for the active period (Daily/Monthly/Yearly).
  final String Function(LedgerPeriod, AppLocalizations) titleFor;

  String _subtitle(LedgerPeriod p, AppLocalizations l10n) => switch (p) {
    LedgerPeriod.daily => l10n.chartLast7Days,
    LedgerPeriod.monthly => l10n.chartLast7Months,
    LedgerPeriod.yearly => l10n.chartLast5Years,
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<LedgerCubit, LedgerState>(
      builder: (context, state) {
        final s = state.series;
        return Container(
          height: 280,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: context.colors.shadow,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      titleFor(state.period, l10n),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                  PeriodDropdown(
                    selected: state.period,
                    onChanged: (p) => context.read<LedgerCubit>().setPeriod(p),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: LedgerLineChart(
                  period: state.period,
                  labelDates: s.labelDates,
                  maxY: s.maxY,
                  incomeSpots: view != LedgerView.expense
                      ? s.incomeSpots
                      : null,
                  expenseSpots: view != LedgerView.income
                      ? s.expenseSpots
                      : null,
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  _subtitle(state.period, l10n),
                  style: TextStyle(fontSize: 11, color: colors.textSecondary),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
