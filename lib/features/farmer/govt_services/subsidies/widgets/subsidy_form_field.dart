import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/widgets/app_date_field.dart';
import 'package:smart_kishan/core/widgets/app_dropdown.dart';
import 'package:smart_kishan/core/widgets/app_text_field.dart';

import '../data/application_form_field.dart';

/// Renders one server-defined application field via the app's shared inputs
/// ([AppTextField], [AppDropdown]). Text-style fields use [controller];
/// choice fields use [value] + [onChanged].
class SubsidyFormField extends StatelessWidget {
  const SubsidyFormField({
    super.key,
    required this.field,
    this.controller,
    this.value,
    this.onChanged,
  });

  final ApplicationFormField field;
  final TextEditingController? controller;
  final dynamic value;
  final ValueChanged<dynamic>? onChanged;

  bool get _locked => field.isPrefilled && !field.prefillEditable;

  @override
  Widget build(BuildContext context) {
    final type = field.fieldType ?? 'text';
    final child = switch (type) {
      'dropdown' => _dropdown(context),
      'radio' => _radio(context),
      'checkbox' =>
        field.allowMultiple ? _checkboxGroup(context) : _checkbox(context),
      'date' => _date(context),
      'textarea' => _textField(context, maxLines: 4),
      _ => _textField(context),
    };
    return Padding(padding: const EdgeInsets.only(bottom: 16), child: child);
  }

  String _rawLabel(BuildContext context) =>
      field.label?.of(context) ?? field.fieldKey ?? '';

  String _labelText(BuildContext context) {
    final base = _rawLabel(context);
    return field.isRequired ? '$base *' : base;
  }

  /// Placeholder text — the server-provided one if present, else a sensible
  /// default: "Please enter <label>" (inputs) / "Please select <label>" (choice).
  String _hint(BuildContext context, {required bool select}) {
    final l10n = AppLocalizations.of(context)!;
    final ph = field.placeholder?.of(context);
    if (ph != null && ph.isNotEmpty) return ph;
    final label = _rawLabel(context);
    return select
        ? l10n.subsidyPleaseSelect(label)
        : l10n.subsidyPleaseEnter(label);
  }

  String? _validate(BuildContext context, String? v, {bool number = false}) {
    final l10n = AppLocalizations.of(context)!;
    final custom = field.validationMessage?.of(context);
    String fallback(String s) => custom?.isNotEmpty == true ? custom! : s;
    final value = v?.trim() ?? '';

    if (field.isRequired && value.isEmpty) {
      return fallback(l10n.subsidyFieldRequiredNamed(_rawLabel(context)));
    }
    if (value.isEmpty) return null;
    if (field.fieldType == 'email' &&
        !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
      return l10n.subsidyInvalidEmail;
    }
    if (number) {
      final n = num.tryParse(value);
      if (n == null) return l10n.subsidyInvalidNumber;
      if (field.minValue != null && n < field.minValue!)
        return fallback(l10n.subsidyInvalidValue);
      if (field.maxValue != null && n > field.maxValue!)
        return fallback(l10n.subsidyInvalidValue);
    }
    if (field.minLength != null && value.length < field.minLength!)
      return fallback(l10n.subsidyInvalidValue);
    if (field.maxLength != null && value.length > field.maxLength!)
      return fallback(l10n.subsidyInvalidValue);
    return null;
  }

  Widget _textField(BuildContext context, {int maxLines = 1}) {
    final type = field.fieldType;
    final isNumber = type == 'number';
    final tf = AppTextField(
      controller: controller!,
      label: _labelText(context),
      hint: _hint(context, select: false),
      maxLines: maxLines,
      keyboardType: isNumber
          ? const TextInputType.numberWithOptions(decimal: true)
          : type == 'email'
          ? TextInputType.emailAddress
          : type == 'phone'
          ? TextInputType.phone
          : TextInputType.text,
      inputFormatters: isNumber
          ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))]
          : type == 'phone'
          ? [FilteringTextInputFormatter.digitsOnly]
          : null,
      suffixIcon: _locked
          ? Icon(
              Icons.lock_outline,
              size: 16,
              color: context.colors.iconSecondary,
            )
          : null,
      validator: (v) => _validate(context, v, number: isNumber),
    );
    return _locked ? AbsorbPointer(child: tf) : tf;
  }

  Widget _date(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppDateField(
      value: value as DateTime?,
      onChanged: (v) => onChanged?.call(v),
      label: _labelText(context),
      hint: _hint(context, select: false),
      validator: (v) => field.isRequired && v == null
          ? l10n.subsidyFieldRequiredNamed(_rawLabel(context))
          : null,
    );
  }

  Widget _dropdown(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final l10n = AppLocalizations.of(context)!;
    final values = field.options.map((o) => o.value ?? '').toList();
    final current = (value as String?)?.isEmpty == true
        ? null
        : value as String?;
    return AppDropdown<String>(
      label: _labelText(context),
      value: values.contains(current) ? current : null,
      items: values,
      itemLabel: (v) => field.options
          .firstWhere((o) => o.value == v, orElse: () => const FieldOption())
          .labelFor(lang),
      hint: _hint(context, select: true),
      validator: (v) => field.isRequired && (v == null || v.isEmpty)
          ? l10n.subsidyFieldRequiredNamed(_rawLabel(context))
          : null,
      onChanged: _locked ? (_) {} : (v) => onChanged?.call(v),
    );
  }

  Widget _radio(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _labelText(context),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: context.colors.textPrimary,
          ),
        ),
        FormField<String>(
          initialValue: value as String?,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (v) => field.isRequired && (v == null || v.isEmpty)
              ? l10n.subsidyFieldRequiredNamed(_rawLabel(context))
              : null,
          builder: (state) {
            final colors = context.colors;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RadioGroup<String>(
                  groupValue: state.value,
                  onChanged: (v) {
                    state.didChange(v);
                    onChanged?.call(v);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: field.options.map((o) {
                      final v = o.value ?? '';
                      void select() {
                        state.didChange(v);
                        onChanged?.call(v);
                      }

                      return InkWell(
                        onTap: select,
                        borderRadius: BorderRadius.circular(8),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: 44),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: Radio<String>(
                                  value: v,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(child: Text(o.labelFor(lang))),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
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

  Widget _checkbox(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    return FormField<bool>(
      initialValue: value as bool? ?? false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (v) => field.isRequired && v != true
          ? l10n.subsidyFieldRequiredNamed(_rawLabel(context))
          : null,
      builder: (state) {
        void toggle() {
          final next = !(state.value ?? false);
          state.didChange(next);
          onChanged?.call(next);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _labelText(context),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
            InkWell(
              onTap: toggle,
              borderRadius: BorderRadius.circular(8),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 44),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Checkbox(
                        value: state.value ?? false,
                        onChanged: (_) => toggle(),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        field.placeholder?.of(context) ?? field.fieldKey ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                  ],
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
    );
  }

  Widget _checkboxGroup(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final l10n = AppLocalizations.of(context)!;
    final selected = (value as List<String>?) ?? const <String>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _labelText(context),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: context.colors.textPrimary,
          ),
        ),
        FormField<List<String>>(
          initialValue: selected,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (v) => field.isRequired && (v == null || v.isEmpty)
              ? l10n.subsidyFieldRequiredNamed(_rawLabel(context))
              : null,
          builder: (state) {
            final colors = context.colors;
            final current = state.value ?? const <String>[];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ...field.options.map((o) {
                  final optValue = o.value ?? '';
                  final checked = current.contains(optValue);
                  void toggle() {
                    final updated = List<String>.from(current);
                    if (checked) {
                      updated.remove(optValue);
                    } else {
                      updated.add(optValue);
                    }
                    state.didChange(updated);
                    onChanged?.call(updated);
                  }

                  return InkWell(
                    onTap: toggle,
                    borderRadius: BorderRadius.circular(8),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 44),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Checkbox(
                              value: checked,
                              onChanged: (_) => toggle(),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: Text(o.labelFor(lang))),
                        ],
                      ),
                    ),
                  );
                }),
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
}
