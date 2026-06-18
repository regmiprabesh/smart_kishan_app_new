import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/utils/formatters.dart';
import 'package:smart_kishan/features/farmer/ledger/data/ledger_aggregator.dart';

/// Renders the ledger line chart. Pass one or both series:
///   - income screen → incomeSpots only
///   - expense screen → expenseSpots only
///   - chart screen → both (two lines)
/// X labels come from [labelDates], formatted per [period] at build time so
/// they react to locale.
class LedgerLineChart extends StatelessWidget {
  const LedgerLineChart({
    super.key,
    required this.period,
    required this.labelDates,
    required this.maxY,
    this.incomeSpots,
    this.expenseSpots,
  });

  final LedgerPeriod period;
  final List<DateTime> labelDates;
  final double maxY;
  final List<FlSpot>? incomeSpots;
  final List<FlSpot>? expenseSpots;

  String _axisLabel(DateTime d, BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    switch (period) {
      case LedgerPeriod.daily:
        return DateFormat('E', lang).format(d); // weekday
      case LedgerPeriod.monthly:
        return DateFormat('MMM', lang).format(d); // month short
      case LedgerPeriod.yearly:
        return context.ld(d.year); // localized year digits
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final bars = <LineChartBarData>[
      if (incomeSpots != null) _line(incomeSpots!, colors.success),
      if (expenseSpots != null) _line(expenseSpots!, colors.error),
    ];

    return LineChart(
      LineChartData(
        minX: 0,
        minY: 0,
        maxX: (labelDates.length - 1).toDouble(),
        maxY: maxY,
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            getTooltipColor: (_) => colors.primary,
            getTooltipItems: (spots) => spots.map((s) {
              final i = s.x.toInt();
              final label = (i >= 0 && i < labelDates.length)
                  ? _axisLabel(labelDates[i], context)
                  : '';
              final l10n = AppLocalizations.of(context)!;
              return LineTooltipItem(
                '$label\n',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
                children: [
                  TextSpan(
                    text:
                        '${l10n.currencySymbol} ${context.ld(s.y.toStringAsFixed(0))}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
        borderData: FlBorderData(border: const Border()),
        gridData: FlGridData(
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) =>
              FlLine(color: colors.divider, strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(),
          topTitles: const AxisTitles(),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              interval: 1,
              showTitles: true,
              reservedSize: 32,
              getTitlesWidget: (value, meta) {
                final i = value.toInt();
                if (i < 0 || i >= labelDates.length) {
                  return const SizedBox.shrink();
                }
                return SideTitleWidget(
                  space: 15,
                  meta: meta,
                  child: Text(
                    _axisLabel(labelDates[i], context),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: colors.textSecondary,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 44,
              getTitlesWidget: (value, meta) {
                if (value == 0) return const SizedBox.shrink();
                return Text(
                  context.ld(value.toInt()),
                  style: TextStyle(fontSize: 9, color: colors.textSecondary),
                );
              },
            ),
          ),
        ),
        lineBarsData: bars,
      ),
    );
  }

  LineChartBarData _line(List<FlSpot> spots, Color color) => LineChartBarData(
    spots: spots,
    color: color,
    isCurved: true,
    curveSmoothness: 0.3,
    barWidth: 3,
    isStrokeCapRound: true,
    dotData: const FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
  );
}
