import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/widgets/app_bar.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/features/farmer/ledger/cubit/ledger_cubit.dart';
import 'package:smart_kishan/features/farmer/ledger/cubit/ledger_state.dart';
import 'package:smart_kishan/features/farmer/ledger/data/ledger_aggregator.dart';
import 'package:smart_kishan/features/farmer/ledger/widgets/ledger_activity_list.dart';
import 'package:smart_kishan/features/farmer/ledger/widgets/ledger_chart_card.dart';

/// Ledger chart: both income + expense lines, plus a combined period-filtered
/// activity list.
class LedgerChartScreen extends StatelessWidget {
  const LedgerChartScreen({super.key, required this.cubit});
  final LedgerCubit cubit;

  String _chartTitle(LedgerPeriod p, AppLocalizations l10n) => switch (p) {
    LedgerPeriod.daily => l10n.chartIncomeExpenseTitle(l10n.chartFilterDaily),
    LedgerPeriod.monthly => l10n.chartIncomeExpenseTitle(
      l10n.chartFilterMonthly,
    ),
    LedgerPeriod.yearly => l10n.chartIncomeExpenseTitle(l10n.chartFilterYearly),
  };

  String _listTitle(LedgerPeriod p, AppLocalizations l10n) =>
      '${l10n.financialRecords} · ${_period(p, l10n)}';

  String _period(LedgerPeriod p, AppLocalizations l10n) => switch (p) {
    LedgerPeriod.daily => l10n.chartLast7Days,
    LedgerPeriod.monthly => l10n.chartLast7Months,
    LedgerPeriod.yearly => l10n.chartLast5Years,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider.value(
      value: cubit,
      child: Column(
        children: [
          AppAppBar(title: l10n.chartScreenTitle),
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LedgerChartCard(view: LedgerView.both, titleFor: _chartTitle),
                  // Legend
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                    child: Row(
                      children: [
                        _LegendDot(label: l10n.income, isIncome: true),
                        const SizedBox(width: 16),
                        _LegendDot(label: l10n.expense, isIncome: false),
                      ],
                    ),
                  ),
                  BlocBuilder<LedgerCubit, LedgerState>(
                    builder: (context, state) => LedgerActivityList(
                      title: _listTitle(state.period, l10n),
                      activities: context.read<LedgerCubit>().ledgerActivities,
                      amountMode: LedgerAmount.auto,
                      emptyTitle: l10n.financialRecordsEmpty,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.label, required this.isIncome});
  final String label;
  final bool isIncome;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = isIncome ? colors.success : colors.error;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: colors.textSecondary),
        ),
      ],
    );
  }
}
