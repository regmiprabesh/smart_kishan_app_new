import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';

class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.hint,
    this.validator,
    this.label,
    this.showLabel = true,
  });

  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T?> onChanged;
  final String? hint;
  final String? Function(T?)? validator;
  final String? label;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel && label != null) ...[
          Text(
            label!,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
        ],
        FormField<T>(
          initialValue: value,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InputDecorator(
                  isEmpty: value == null,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 4,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: state.hasError ? colors.error : colors.border,
                      ),
                    ),
                    // Suppress the built-in error text/indent — rendered
                    // manually below so its padding is independent of
                    // contentPadding.
                    errorText: state.hasError ? '' : null,
                    errorStyle: const TextStyle(height: 0, fontSize: 0),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<T>(
                      value: value,
                      isExpanded: true,
                      isDense: true,
                      hint: hint != null
                          ? Text(
                              hint!,
                              style: TextStyle(
                                color: colors.textHint,
                                fontSize: 14,
                              ),
                            )
                          : null,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: colors.primary,
                      ),
                      dropdownColor: colors.surface,
                      style: TextStyle(color: colors.textPrimary, fontSize: 15),
                      items: [
                        for (final item in items)
                          DropdownMenuItem(
                            value: item,
                            child: Text(itemLabel(item)),
                          ),
                      ],
                      onChanged: (v) {
                        onChanged(v);
                        state.didChange(v);
                      },
                    ),
                  ),
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(left: 0, top: 6),
                    child: Text(
                      state.errorText!,
                      style: TextStyle(color: colors.error, fontSize: 12),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
