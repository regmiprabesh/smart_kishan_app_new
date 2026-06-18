import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/widgets/app_bar.dart';
import 'package:smart_kishan/features/farmer/ledger/cubit/ledger_cubit.dart';
import 'package:smart_kishan/features/farmer/ledger/cubit/ledger_state.dart';
import 'package:smart_kishan/features/farmer/ledger/data/ledger_aggregator.dart';
import 'package:smart_kishan/features/farmer/ledger/widgets/ledger_activity_list.dart';
import 'package:smart_kishan/features/farmer/ledger/widgets/ledger_chart_card.dart';

/// Income analysis: income-only chart + period-filtered income list.
class IncomeScreen extends StatelessWidget {
  const IncomeScreen({super.key, required this.cubit});
  final LedgerCubit cubit;

  String _chartTitle(LedgerPeriod p, AppLocalizations l10n) => switch (p) {
    LedgerPeriod.daily => l10n.chartIncomeTitle(l10n.chartFilterDaily),
    LedgerPeriod.monthly => l10n.chartIncomeTitle(l10n.chartFilterMonthly),
    LedgerPeriod.yearly => l10n.chartIncomeTitle(l10n.chartFilterYearly),
  };

  String _listTitle(LedgerPeriod p, AppLocalizations l10n) =>
      '${l10n.myIncome} · ${_period(p, l10n)}';

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
      child: Scaffold(
        appBar: AppAppBar(title: l10n.chartIncomeAnalysis),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LedgerChartCard(view: LedgerView.income, titleFor: _chartTitle),
              BlocBuilder<LedgerCubit, LedgerState>(
                builder: (context, state) => LedgerActivityList(
                  title: _listTitle(state.period, l10n),
                  activities: context.read<LedgerCubit>().incomeActivities,
                  amountMode: LedgerAmount.income,
                  emptyTitle: l10n.chartIncomeEmpty,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
