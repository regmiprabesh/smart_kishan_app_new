import 'multilingual_field.dart';

/// Shared administrative-location models — Nepal's province → district →
/// municipality → ward hierarchy. Used by the user's address, service centers,
/// subsidies, delivery addresses, marketplace listings, etc. Single source of
/// truth: do NOT create feature-local copies (no UserProvince, no
/// ServiceCenterProvince — everything points here).
///
/// All `name` fields are [MultilingualField] (backend sends {en, ne} or a
/// plain string; the factory tolerates both).

class Province {
  int? id;
  MultilingualField? name;

  /// Some endpoints send a flat `province_name` alongside the structured name.
  String? provinceName;

  Province({this.id, this.name, this.provinceName});

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      id: json['id'],
      name: MultilingualField.fromJson(json['name']),
      provinceName: json['province_name'],
    );
  }
}

class District {
  int? id;
  MultilingualField? name;

  District({this.id, this.name});

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      id: json['id'],
      name: MultilingualField.fromJson(json['name']),
    );
  }
}

class Municipality {
  int? id;
  MultilingualField? name;

  /// e.g. "Metropolitan", "Sub-Metropolitan", "Rural Municipality".
  String? type;

  Municipality({this.id, this.name, this.type});

  factory Municipality.fromJson(Map<String, dynamic> json) {
    return Municipality(
      id: json['id'],
      name: MultilingualField.fromJson(json['name']),
      type: json['type'],
    );
  }
}

class Ward {
  int? id;
  MultilingualField? name;
  int? wardNumber;

  Ward({this.id, this.name, this.wardNumber});

  factory Ward.fromJson(Map<String, dynamic> json) {
    return Ward(
      id: json['id'],
      name: MultilingualField.fromJson(json['name']),
      wardNumber: json['ward_number'],
    );
  }
}
