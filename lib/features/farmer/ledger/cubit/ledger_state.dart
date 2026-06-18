import 'package:equatable/equatable.dart';
import 'package:smart_kishan/features/farmer/daily_activity/data/activity.dart';
import 'package:smart_kishan/features/farmer/ledger/data/ledger_aggregator.dart';

class LedgerState extends Equatable {
  const LedgerState({
    required this.activities,
    required this.period,
    required this.series,
  });

  final List<Activity> activities;
  final LedgerPeriod period;
  final LedgerSeries series;

  LedgerState copyWith({
    List<Activity>? activities,
    LedgerPeriod? period,
    LedgerSeries? series,
  }) {
    return LedgerState(
      activities: activities ?? this.activities,
      period: period ?? this.period,
      series: series ?? this.series,
    );
  }

  @override
  List<Object?> get props => [activities, period, series];
}
