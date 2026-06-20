import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';

/// Search field shown above the service-center list/map. Pass [enabled] = false
/// to render a static, non-interactive copy (used by the loading skeleton).
class ServiceCenterSearchBar extends StatelessWidget {
  const ServiceCenterSearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.enabled = true,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: TextField(
        controller: controller,
        enabled: enabled,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: l10n.searchServiceCentersHint,
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: colors.surfaceAlt,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }
}
