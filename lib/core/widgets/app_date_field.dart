import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';

/// Dedicated date-picker field. Owns a [DateTime] value directly (no
/// [TextEditingController]), so validation reacts immediately to picks via
/// [FormField.didChange] — no controller-listener workaround needed.
class AppDateField extends StatelessWidget {
  const AppDateField({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.hint,
    this.validator,
    this.firstDate,
    this.lastDate,
    this.dateFormat,
    this.showLabel = true,
  });

  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final String label;
  final String? hint;
  final String? Function(DateTime?)? validator;
  final DateTime? firstDate;
  final DateTime? lastDate;

  /// Formats the picked date for display. Defaults to ISO `yyyy-MM-dd`.
  final String Function(DateTime)? dateFormat;
  final bool showLabel;

  String _format(DateTime d) =>
      dateFormat?.call(d) ?? d.toIso8601String().split('T').first;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel) ...[
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
        ],
        FormField<DateTime>(
          initialValue: value,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => _pick(context, state),
                  child: InputDecorator(
                    isEmpty: state.value == null,
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: TextStyle(
                        color: colors.textHint,
                        fontSize: 14,
                      ),
                      suffixIcon: Icon(
                        Icons.calendar_today_outlined,
                        size: 18,
                        color: colors.iconSecondary,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
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
                      // Suppressed — rendered manually below, independent
                      // of contentPadding.
                      errorText: state.hasError ? '' : null,
                      errorStyle: const TextStyle(height: 0, fontSize: 0),
                    ),
                    child: Text(
                      state.value != null ? _format(state.value!) : '',
                      style: TextStyle(color: colors.textPrimary, fontSize: 15),
                    ),
                  ),
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
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

  Future<void> _pick(
    BuildContext context,
    FormFieldState<DateTime> state,
  ) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: state.value ?? now,
      firstDate: firstDate ?? DateTime(now.year - 5),
      lastDate: lastDate ?? DateTime(now.year + 5),
    );
    if (picked != null) {
      state.didChange(picked);
      onChanged(picked);
    }
  }
}
