import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// App-wide formatting helpers. The key one for bilingual UIs:
/// digit localization. ICU `{placeholder}` substitution does NOT convert
/// numerals — it drops your string in as-is — so a count like "60" stays
/// in ASCII even under a Nepali locale. Run user-facing numbers through
/// [localizedDigits] (or the extensions) so they render ६० in Nepali.
abstract final class AppFormatters {
  static const _devanagari = ['०', '१', '२', '३', '४', '५', '६', '७', '८', '९'];

  /// Convert ASCII digits 0-9 in [input] to the script of [languageCode].
  /// Only 'ne' is non-Latin today; everything else passes through.
  static String localizedDigits(String input, String languageCode) {
    if (languageCode != 'ne') return input;
    final buffer = StringBuffer();
    for (final unit in input.codeUnits) {
      if (unit >= 0x30 && unit <= 0x39) {
        buffer.write(_devanagari[unit - 0x30]);
      } else {
        buffer.writeCharCode(unit);
      }
    }
    return buffer.toString();
  }

  /// Locale-aware date formatter for cards/footers. Parses an ISO date string,
  /// formats as "d MMM, y" in the given locale, and localizes the digits.
  /// Returns '' for null/unparseable input.
  static String shortDate(String? raw, String languageCode) {
    if (raw == null) return '';
    final dt = DateTime.tryParse(raw);
    if (dt == null) return '';
    final formatted = DateFormat('d MMM, y', languageCode).format(dt);
    return localizedDigits(formatted, languageCode);
  }
}

/// Ergonomic, locale-aware versions you can call from any widget:
///   context.ld(seconds)          // num/String → localized-digit String
extension LocalizedDigitsX on BuildContext {
  String ld(Object value) => AppFormatters.localizedDigits(
    value.toString(),
    Localizations.localeOf(this).languageCode,
  );
  String shortDate(String? raw) =>
      AppFormatters.shortDate(raw, Localizations.localeOf(this).languageCode);
}
