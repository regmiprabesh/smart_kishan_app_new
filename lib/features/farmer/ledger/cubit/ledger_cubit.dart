import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_kishan/features/farmer/daily_activity/cubit/daily_activity_cubit.dart';
import 'package:smart_kishan/features/farmer/daily_activity/cubit/daily_activity_state.dart';
import 'package:smart_kishan/features/farmer/daily_activity/data/activity.dart';
import 'package:smart_kishan/features/farmer/ledger/cubit/ledger_state.dart';
import 'package:smart_kishan/features/farmer/ledger/data/ledger_aggregator.dart';

/// Derives chart series from DailyActivityCubit — the single source of truth.
/// Fetches nothing: it seeds from the activities already loaded, then listens
/// so any add/edit/delete (or, later, an offline sync) re-aggregates
/// automatically.
///
/// Used by the Income, Expense, and Chart screens (each reads the same state,
/// shows a different slice).
class LedgerCubit extends Cubit<LedgerState> {
  LedgerCubit(
    this._dailyActivityCubit, {
    LedgerPeriod period = LedgerPeriod.daily,
  }) : super(
         LedgerState(
           activities: _activitiesOf(_dailyActivityCubit.state),
           period: period,
           series: LedgerAggregator.aggregate(
             _activitiesOf(_dailyActivityCubit.state),
             period,
           ),
         ),
       ) {
    // Re-aggregate whenever the activity source changes.
    _sub = _dailyActivityCubit.stream.listen((state) {
      updateActivities(_activitiesOf(state));
    });
  }

  final DailyActivityCubit _dailyActivityCubit;
  late final StreamSubscription<DailyActivityState> _sub;

  static List<Activity> _activitiesOf(DailyActivityState state) =>
      state is DailyActivityLoaded ? state.activities : const [];

  /// Change the period filter (Daily/Monthly/Yearly) → re-aggregate.
  void setPeriod(LedgerPeriod period) {
    emit(
      state.copyWith(
        period: period,
        series: LedgerAggregator.aggregate(state.activities, period),
      ),
    );
  }

  /// Feed a fresh activity list → re-aggregate for the current period.
  void updateActivities(List<Activity> activities) {
    emit(
      state.copyWith(
        activities: activities,
        series: LedgerAggregator.aggregate(activities, state.period),
      ),
    );
  }

  /// Income entries within the selected period, newest first.
  List<Activity> get incomeActivities => LedgerAggregator.inPeriod(
    state.activities.where((a) => a.income != null).toList(),
    state.period,
  );

  /// Expense entries within the selected period, newest first.
  List<Activity> get expenseActivities => LedgerAggregator.inPeriod(
    state.activities.where((a) => a.expense != null).toList(),
    state.period,
  );

  /// All entries with any amount within the period — chart screen's list.
  List<Activity> get ledgerActivities => LedgerAggregator.inPeriod(
    state.activities
        .where((a) => a.income != null || a.expense != null)
        .toList(),
    state.period,
  );

  @override
  Future<void> close() {
    _sub.cancel(); // prevent the stream-subscription leak
    return super.close();
  }
}
