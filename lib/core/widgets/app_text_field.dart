import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.validator,
    this.keyboardType,
    this.prefixIcon,
    this.prefixText,
    this.obscureText = false,
    this.suffixIcon,
    this.textInputAction = TextInputAction.next,
    this.maxLength,
    this.inputFormatters,
    this.maxLines = 1,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.showLabel = true,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final String? prefixText;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputAction textInputAction;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final AutovalidateMode autovalidateMode;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
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
        FormField<String>(
          initialValue: controller.text,
          validator: validator,
          autovalidateMode: autovalidateMode,
          builder: (state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: controller,
                  keyboardType: keyboardType,
                  obscureText: obscureText,
                  textInputAction: textInputAction,
                  maxLength: maxLength,
                  maxLines: maxLines,
                  inputFormatters: inputFormatters,
                  onChanged: (v) => state.didChange(v),
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  decoration: InputDecoration(
                    hintText: hint,
                    counterText: '',
                    prefixIcon: prefixIcon,
                    prefixText: prefixText,
                    suffixIcon: suffixIcon,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: context.colors.border),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: context.colors.error),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: context.colors.error,
                        width: 2,
                      ),
                    ),
                    // Hide the built-in error text — rendered manually below.
                    errorText: state.hasError ? '' : null,
                    errorStyle: const TextStyle(height: 0, fontSize: 0),
                  ),
                ),
                if (state.hasError)
                  Padding(
                    // Independent of contentPadding — set whatever you want here.
                    padding: const EdgeInsets.only(left: 0, top: 6),
                    child: Text(
                      state.errorText!,
                      style: TextStyle(
                        color: context.colors.error,
                        fontSize: 12,
                      ),
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

/// Phone preset: (+977) | prefix, digits only, 10 max.
class PhoneField extends StatelessWidget {
  const PhoneField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      label: label,
      hint: hint,
      validator: validator,
      keyboardType: TextInputType.phone,
      prefixIcon: Padding(
        padding: const EdgeInsets.only(
          top: 15,
          bottom: 15,
          left: 15,
          right: 10,
        ),
        child: Text(
          '(+977) |',
          style: TextStyle(fontSize: 14, color: context.colors.textSecondary),
        ),
      ),
      maxLength: 10,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }
}

/// Password preset with show/hide toggle.
class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.validator,
    this.textInputAction = TextInputAction.done,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: widget.controller,
      label: widget.label,
      hint: widget.hint,
      validator: widget.validator,
      obscureText: _obscured,
      prefixIcon: const Icon(Icons.lock_outline),
      textInputAction: widget.textInputAction,
      suffixIcon: IconButton(
        icon: Icon(
          _obscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        ),
        onPressed: () => setState(() => _obscured = !_obscured),
      ),
    );
  }
}
