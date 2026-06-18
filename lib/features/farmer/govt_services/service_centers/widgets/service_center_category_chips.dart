import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';

import '../data/service_center.dart';
import 'service_center_type_style.dart';

/// Horizontally-scrolling category filter under the search bar — "All" plus one
/// chip per [ServiceCenterType], always visible (separate from the filter/sort
/// sheet). Mirrors the original सबै / कृषि ज्ञान केन्द्र / बीउ आपूर्ति केन्द्र row.
/// Passing null to [onSelected] means "All".
class ServiceCenterCategoryChips extends StatelessWidget {
  const ServiceCenterCategoryChips({
    super.key,
    required this.types,
    required this.selectedTypeId,
    required this.onSelected,
  });

  final List<ServiceCenterType> types;
  final int? selectedTypeId;
  final ValueChanged<int?> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;

    return SizedBox(
      height: 55,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          children: [
            // "All" — uses primary + a check when active (matches the original).
            _Chip(
              label: l10n.commonAll,
              color: colors.primary,
              selected: selectedTypeId == null,
              leading: selectedTypeId == null
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
              filledWhenSelected: true,
              onTap: () => onSelected(null),
            ),
            const SizedBox(width: 8),
            ...types.map((t) {
              final c = ServiceCenterTypeStyle.of(t);
              final selected = selectedTypeId == t.id;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _Chip(
                  label: t.name?.of(context) ?? '',
                  color: c,
                  selected: selected,
                  filledWhenSelected: true,
                  leading: Icon(
                    selected ? Icons.check : ServiceCenterTypeStyle.iconOf(t),
                    size: selected ? 16 : 15,
                    color: selected ? Colors.white : colors.textSecondary,
                  ),
                  onTap: () => onSelected(t.id),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
    this.leading,
    this.filledWhenSelected = false,
  });

  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;
  final Widget? leading;
  final bool filledWhenSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final solid = selected && filledWhenSelected;

    final bg = solid
        ? color
        : selected
        ? color.withValues(alpha: 0.12)
        : colors.surface;
    final fg = solid
        ? Colors.white
        : selected
        ? color
        : colors.textSecondary;

    return Center(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          height: 38,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? color : colors.border,
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leading != null) ...[
                // Recolor a provided leading icon for the solid state.
                solid && leading is Icon
                    ? Icon(
                        (leading as Icon).icon,
                        size: (leading as Icon).size,
                        color: Colors.white,
                      )
                    : leading!,
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: fg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
