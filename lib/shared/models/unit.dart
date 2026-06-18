import 'package:smart_kishan/shared/models/multilingual_field.dart';

/// Measurement unit (kg, litre, …) from `/units`. Name may be a plain string
/// or a localized map depending on backend; we read a display string.
class Unit {
  const Unit({this.id, this.name, this.code});
  final int? id;
  final MultilingualField? name;
  final MultilingualField? code;

  factory Unit.fromJson(Map<String, dynamic> json) => Unit(
    id: json['id'] as int?,
    name: MultilingualField.fromJson(json['name']),
    code: MultilingualField.fromJson(json['code']),
  );
}
