import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:smart_kishan/features/farmer/daily_activity/data/activity.dart';

/// The period filter for the ledger charts.
enum LedgerPeriod { daily, monthly, yearly }

/// Result of aggregating activities for one period: the chart spots plus the
/// reference dates for the X-axis labels (formatted at the widget layer so
/// they react to locale).
class LedgerSeries {
  const LedgerSeries({
    required this.incomeSpots,
    required this.expenseSpots,
    required this.labelDates,
    required this.maxY,
  });

  final List<FlSpot> incomeSpots;
  final List<FlSpot> expenseSpots;
  final List<DateTime> labelDates;
  final double maxY;
}

/// Buckets a list of activities into per-period income/expense sums. This is
/// the single shared implementation that income, expense, and chart all use —
/// no per-screen duplication, and it reads activities already in memory (no
/// API calls).
class LedgerAggregator {
  static const int _dayCount = 7;
  static const int _monthCount = 7;
  static const int _yearCount = 5;

  static final DateFormat _dayKeyFmt = DateFormat('yyyy-MM-dd');
  static final DateFormat _monthKeyFmt = DateFormat('yyyy-MM');
  static final DateFormat _yearKeyFmt = DateFormat('yyyy');

  /// Build the income + expense series for [activities] over [period].
  static LedgerSeries aggregate(
    List<Activity> activities,
    LedgerPeriod period,
  ) {
    final (dates, keyFmt) = _buckets(period);
    final keys = dates.map(keyFmt.format).toList();

    final incomeSpots = _plot(
      activities.where((a) => a.income != null).toList(),
      keys,
      keyFmt,
      (a) => a.income ?? 0,
    );
    final expenseSpots = _plot(
      activities.where((a) => a.expense != null).toList(),
      keys,
      keyFmt,
      (a) => a.expense ?? 0,
    );

    final maxY = [
      ..._ys(incomeSpots),
      ..._ys(expenseSpots),
    ].fold<double>(0, (m, y) => y > m ? y : m);

    return LedgerSeries(
      incomeSpots: incomeSpots,
      expenseSpots: expenseSpots,
      labelDates: dates,
      maxY: maxY == 0 ? 1 : maxY, // avoid a 0-height chart
    );
  }

  /// Reference dates (oldest→newest) + the ASCII key formatter for [period].
  static (List<DateTime>, DateFormat) _buckets(LedgerPeriod period) {
    final now = DateTime.now();
    switch (period) {
      case LedgerPeriod.monthly:
        return (
          [
            for (var i = _monthCount - 1; i >= 0; i--)
              DateTime(now.year, now.month - i),
          ],
          _monthKeyFmt,
        );
      case LedgerPeriod.yearly:
        return (
          [for (var i = _yearCount - 1; i >= 0; i--) DateTime(now.year - i)],
          _yearKeyFmt,
        );
      case LedgerPeriod.daily:
        return (
          [
            for (var i = _dayCount - 1; i >= 0; i--)
              DateTime(now.year, now.month, now.day - i),
          ],
          _dayKeyFmt,
        );
    }
  }

  /// Sums [valueOf] for each bucket → one FlSpot per bucket (X=index, Y=sum).
  static List<FlSpot> _plot(
    List<Activity> data,
    List<String> bucketKeys,
    DateFormat keyFmt,
    double Function(Activity) valueOf,
  ) {
    final grouped = groupBy<Activity, String>(
      data.where((a) => a.date != null),
      (a) {
        final dt = DateTime.tryParse(a.date!);
        return dt == null ? '' : keyFmt.format(dt.toLocal());
      },
    );

    return [
      for (var i = 0; i < bucketKeys.length; i++)
        FlSpot(
          i.toDouble(),
          (grouped[bucketKeys[i]] ?? const <Activity>[]).fold<double>(
            0,
            (sum, a) => sum + valueOf(a),
          ),
        ),
    ];
  }

  static Iterable<double> _ys(List<FlSpot> spots) => spots.map((s) => s.y);

  /// The earliest date included in [period]'s window (for filtering lists to
  /// "last 7 days / 7 months / 5 years").
  static DateTime periodStart(LedgerPeriod period) {
    final now = DateTime.now();
    switch (period) {
      case LedgerPeriod.daily:
        return DateTime(now.year, now.month, now.day - (_dayCount - 1));
      case LedgerPeriod.monthly:
        return DateTime(now.year, now.month - (_monthCount - 1));
      case LedgerPeriod.yearly:
        return DateTime(now.year - (_yearCount - 1));
    }
  }

  /// Filters [activities] to those within [period]'s window, newest first.
  static List<Activity> inPeriod(
    List<Activity> activities,
    LedgerPeriod period,
  ) {
    final start = periodStart(period);
    final filtered = activities.where((a) {
      if (a.date == null) return false;
      final dt = DateTime.tryParse(a.date!);
      return dt != null && !dt.isBefore(start);
    }).toList();
    filtered.sort(
      (a, b) => (b.date ?? '').compareTo(a.date ?? ''),
    ); // newest first
    return filtered;
  }
}
