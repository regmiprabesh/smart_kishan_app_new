import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';

/// Shared search field used by the list screens (crop info, market price,
/// service centers): a rounded [surfaceAlt] fill, a search prefix, and a clear
/// button that appears when there's text (and a [controller] to clear).
///
/// Pass [enabled] = false for a static, non-interactive copy — used by loading
/// skeletons so the chrome matches the rendered screen exactly.
class AppSearchField extends StatelessWidget {
  const AppSearchField({
    super.key,
    required this.hintText,
    this.controller,
    this.onChanged,
    this.enabled = true,
    this.padding = const EdgeInsets.fromLTRB(16, 12, 16, 8),
  });

  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final showClear = controller != null && controller!.text.isNotEmpty;

    return Padding(
      padding: padding,
      child: TextField(
        controller: controller,
        enabled: enabled,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(Icons.search, color: colors.iconSecondary),
          suffixIcon: showClear
              ? IconButton(
                  icon: Icon(Icons.close, color: colors.iconSecondary),
                  onPressed: () {
                    controller!.clear();
                    onChanged?.call('');
                  },
                )
              : null,
          filled: true,
          fillColor: colors.surfaceAlt,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
