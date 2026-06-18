import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/utils/formatters.dart';

import '../data/service_center_repository.dart';

/// Result returned by the filter sheet's "Apply" button.
class ServiceCenterFilterResult {
  const ServiceCenterFilterResult({
    this.typeId,
    required this.sortBy,
    required this.radius,
    required this.featuredOnly,
  });

  final int? typeId;
  final String sortBy;
  final double radius;
  final bool featuredOnly;
}

/// Bottom sheet for filtering + sorting service centers. Mirrors the old
/// "Filters & Sort" sheet: type selector, sort options (distance/name/rating/
/// newest), search-radius slider, and a featured-only toggle. Returns a
/// [ServiceCenterFilterResult] via Navigator.pop, or null on dismiss.
class ServiceCenterFilterSheet extends StatefulWidget {
  const ServiceCenterFilterSheet({super.key, required this.query});

  final ServiceCenterQuery query;

  static Future<ServiceCenterFilterResult?> show(
    BuildContext context, {
    required ServiceCenterQuery query,
  }) {
    return showModalBottomSheet<ServiceCenterFilterResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ServiceCenterFilterSheet(query: query),
    );
  }

  @override
  State<ServiceCenterFilterSheet> createState() =>
      _ServiceCenterFilterSheetState();
}

class _ServiceCenterFilterSheetState extends State<ServiceCenterFilterSheet> {
  late int? _typeId = widget.query.typeId;
  late String _sortBy = widget.query.sortBy;
  late double _radius = widget.query.radius ?? 600;
  late bool _featuredOnly = widget.query.featuredOnly;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;

    final sortOptions = <String, String>{
      'distance': l10n.distance,
      'name': l10n.name,
      'rating': l10n.rating,
      'newest': l10n.newest,
    };

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                l10n.filtersAndSort,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  setState(() {
                    _typeId = null;
                    _sortBy = 'distance';
                    _radius = 600;
                    _featuredOnly = false;
                  });
                },
                child: Text(l10n.clearAll),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Sort
          _label(l10n.sortBy, context),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: sortOptions.entries.map((e) {
              return _TypeChip(
                label: e.value,
                selected: _sortBy == e.key,
                color: colors.primary,
                onTap: () => setState(() => _sortBy = e.key),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Radius
          Row(
            children: [
              _label(l10n.searchRadius, context),
              const Spacer(),
              Text(
                '${context.ld(_radius.round().toString())} ${l10n.km}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: colors.primary,
                ),
              ),
            ],
          ),
          Slider(
            value: _radius,
            min: 5,
            max: 600,
            divisions: 119,
            label: '${_radius.round()} ${l10n.km}',
            onChanged: (v) => setState(() => _radius = v),
          ),
          const SizedBox(height: 4),

          // Featured toggle
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.showFeaturedOnly),
            value: _featuredOnly,
            onChanged: (v) => setState(() => _featuredOnly = v),
          ),
          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.pop(
                context,
                ServiceCenterFilterResult(
                  typeId: _typeId,
                  sortBy: _sortBy,
                  radius: _radius,
                  featuredOnly: _featuredOnly,
                ),
              ),
              child: Text(l10n.applyFilters),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text, BuildContext context) => Text(
    text,
    style: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: context.colors.textSecondary,
    ),
  );
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
    this.icon = Icons.location_pin,
  });

  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.14) : colors.surfaceAlt,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? color : colors.border,
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 14,
                color: selected ? color : colors.textSecondary,
              ),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                color: selected ? color : colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
