import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/features/farmer/ledger/data/ledger_aggregator.dart';

/// Daily / Monthly / Yearly selector for the ledger charts.
class PeriodDropdown extends StatelessWidget {
  const PeriodDropdown({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final LedgerPeriod selected;
  final ValueChanged<LedgerPeriod> onChanged;

  String _label(LedgerPeriod p, AppLocalizations l10n) => switch (p) {
    LedgerPeriod.daily => l10n.chartFilterDaily,
    LedgerPeriod.monthly => l10n.chartFilterMonthly,
    LedgerPeriod.yearly => l10n.chartFilterYearly,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timelapse, size: 14, color: colors.primary),
          const SizedBox(width: 4),
          DropdownButtonHideUnderline(
            child: DropdownButton<LedgerPeriod>(
              value: selected,
              isDense: true,
              icon: Icon(Icons.keyboard_arrow_down, color: colors.primary),
              dropdownColor: colors.surface,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
              items: [
                for (final p in LedgerPeriod.values)
                  DropdownMenuItem(value: p, child: Text(_label(p, l10n))),
              ],
              onChanged: (p) {
                if (p != null) onChanged(p);
              },
            ),
          ),
        ],
      ),
    );
  }
}
