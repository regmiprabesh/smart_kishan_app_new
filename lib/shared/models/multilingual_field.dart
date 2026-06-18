import 'package:flutter/material.dart';

class MultilingualField {
  String? en;
  String? ne;

  MultilingualField({this.en, this.ne});

  String get(String lang) {
    if (lang == 'en') return en ?? ne ?? '';
    return ne ?? en ?? '';
  }

  String of(BuildContext context) =>
      get(Localizations.localeOf(context).languageCode);

  static MultilingualField? fromJson(dynamic value) {
    if (value == null) return null;
    if (value is Map) {
      return MultilingualField(
        en: value['en']?.toString(),
        ne: value['ne']?.toString(),
      );
    }
    if (value is String) {
      return MultilingualField(en: value, ne: value);
    }
    return null;
  }
}
