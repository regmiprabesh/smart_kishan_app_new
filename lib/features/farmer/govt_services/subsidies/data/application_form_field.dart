import 'package:smart_kishan/shared/models/multilingual_field.dart';

/// One server-defined field in a subsidy's dynamic application form. The apply
/// screen renders an input per [fieldType]; values are submitted under
/// `form_data[fieldKey]`.
class ApplicationFormField {
  const ApplicationFormField({
    this.fieldKey,
    this.label,
    this.fieldType,
    this.placeholder,
    this.isRequired = false,
    this.isPrefilled = false,
    this.prefillSource,
    this.prefillEditable = true,
    this.allowMultiple = false,
    this.options = const [],
    this.minValue,
    this.maxValue,
    this.minLength,
    this.maxLength,
    this.validationMessage,
  });

  final String? fieldKey;
  final MultilingualField? label;

  /// text | number | email | phone | date | dropdown | textarea | checkbox | radio
  final String? fieldType;
  final MultilingualField? placeholder;
  final bool isRequired;

  /// When true, pre-fill the input from the user's profile via [prefillSource]
  /// (full_name | email | phone | province | district | municipality | ward | address).
  final bool isPrefilled;
  final String? prefillSource;
  final bool prefillEditable;

  /// For `checkbox` only: false = single boolean checkbox (uses [placeholder]
  /// as its label, e.g. "I agree to..."); true = checkbox group with
  /// multiple selectable [options], same shape as `radio`.
  final bool allowMultiple;

  /// For dropdown / radio.
  final List<FieldOption> options;
  final double? minValue;
  final double? maxValue;
  final int? minLength;
  final int? maxLength;
  final MultilingualField? validationMessage;

  factory ApplicationFormField.fromJson(Map<String, dynamic> json) {
    return ApplicationFormField(
      fieldKey: json['field_key'],
      label: MultilingualField.fromJson(json['label']),
      fieldType: json['field_type'],
      placeholder: MultilingualField.fromJson(json['placeholder']),
      isRequired: json['is_required'] ?? false,
      isPrefilled: json['is_prefilled'] ?? false,
      prefillSource: json['prefill_source'],
      prefillEditable: json['prefill_editable'] ?? true,
      allowMultiple: json['allow_multiple'] ?? false,
      options: json['options'] is List
          ? (json['options'] as List)
                .map((o) => FieldOption.fromJson(o as Map<String, dynamic>))
                .toList()
          : const [],
      minValue: (json['min_value'] as num?)?.toDouble(),
      maxValue: (json['max_value'] as num?)?.toDouble(),
      minLength: json['min_length'],
      maxLength: json['max_length'],
      validationMessage: MultilingualField.fromJson(json['validation_message']),
    );
  }
}

/// A selectable option for a dropdown/radio field.
class FieldOption {
  const FieldOption({this.value, this.label, this.labelEn, this.labelNe});

  final String? value;

  /// Single-label fallback (older payloads).
  final String? label;
  final String? labelEn;
  final String? labelNe;

  String labelFor(String lang) => lang == 'ne'
      ? (labelNe ?? labelEn ?? label ?? '')
      : (labelEn ?? label ?? '');

  factory FieldOption.fromJson(Map<String, dynamic> json) {
    return FieldOption(
      value: json['value']?.toString(),
      label: json['label'],
      labelEn: json['label_en'],
      labelNe: json['label_ne'],
    );
  }
}
