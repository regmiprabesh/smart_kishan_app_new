/// All form validation in one place. Messages are passed in (already
/// localized) so this stays l10n-agnostic.
abstract final class Validators {
  static String? required(String? value, String message) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  /// Name: required + minimum length (trimmed). [min] defaults to 3.
  static String? name(
    String? value, {
    required String required,
    required String tooShort,
    int min = 3,
  }) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return required;
    if (v.length < min) return tooShort;
    return null;
  }

  /// Nepali mobile numbers: 10 digits starting with 96/97/98.
  static String? phone(
    String? value, {
    required String required,
    required String invalid,
  }) {
    if (value == null || value.trim().isEmpty) return required;
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (!RegExp(r'^9[678]\d{8}$').hasMatch(digits)) return invalid;
    return null;
  }

  static String? password(
    String? value, {
    required String required,
    required String tooShort,
    int min = 8,
  }) {
    if (value == null || value.isEmpty) return required;
    if (value.length < min) return tooShort;
    return null;
  }

  static String? confirmPassword(
    String? value,
    String original, {
    required String required,
    required String mismatch,
  }) {
    if (value == null || value.isEmpty) return required;
    if (value != original) return mismatch;
    return null;
  }

  static String? emailOptional(String? value, {required String invalid}) {
    if (value == null || value.trim().isEmpty) return null;
    final ok = RegExp(
      r'^[\w\.\-+]+@[\w\-]+(\.[\w\-]+)+$',
    ).hasMatch(value.trim());
    return ok ? null : invalid;
  }
}
