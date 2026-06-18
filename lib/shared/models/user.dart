import 'dart:convert';

import 'package:smart_kishan/shared/models/location.dart';

List<User> userListFromJson(String val) => List<User>.from(
  json.decode(val).map((user) => User.fromJson(user)),
).toList();

class User {
  int? id;
  String? name;
  String? email;
  String? phone;
  int? parentId;
  String? password;
  String? updatedAt;
  String? createdAt;
  String? image;
  String? mode;
  // NEW FIELDS for location
  String? address;
  int? provinceId;
  int? districtId;
  int? municipalityId;
  int? wardId;
  Province? province;
  District? district;
  Municipality? municipality;
  Ward? ward;

  // For prefilling - computed properties
  String? get fullName => name;
  String? get phoneNumber => phone;
  String? get emailAddress => email;

  // Get full address
  String? get fullAddress {
    List<String> addressParts = [];

    if (address != null && address!.isNotEmpty) {
      addressParts.add(address!);
    }
    if (ward != null && ward!.name != null) {
      addressParts.add(ward!.name!.get('en'));
    }
    if (municipality != null && municipality!.name != null) {
      addressParts.add(municipality!.name!.get('en'));
    }
    if (district != null && district!.name != null) {
      addressParts.add(district!.name!.get('en'));
    }
    if (province != null && province!.name != null) {
      addressParts.add(province!.name!.get('en'));
    }

    return addressParts.isNotEmpty ? addressParts.join(', ') : null;
  }

  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.password,
    this.parentId,
    this.updatedAt,
    this.createdAt,
    this.image,
    this.address,
    this.provinceId,
    this.districtId,
    this.municipalityId,
    this.wardId,
    this.province,
    this.district,
    this.municipality,
    this.ward,
    this.mode,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    parentId = json['parent_id'];
    image = json['image'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    mode = json['mode'];
    // NEW: Parse location fields
    address = json['address'];
    provinceId = json['province_id'];
    districtId = json['district_id'];
    municipalityId = json['municipality_id'];
    wardId = json['ward_id'];

    // Parse location objects if available
    province = json['province'] != null
        ? Province.fromJson(json['province'])
        : null;
    district = json['district'] != null
        ? District.fromJson(json['district'])
        : null;
    municipality = json['municipality'] != null
        ? Municipality.fromJson(json['municipality'])
        : null;
    ward = json['ward'] != null ? Ward.fromJson(json['ward']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['parent_id'] = this.parentId;
    data['password'] = this.password;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['image'] = this.image;
    data['address'] = this.address;
    data['province_id'] = this.provinceId;
    data['district_id'] = this.districtId;
    data['municipality_id'] = this.municipalityId;
    data['ward_id'] = this.wardId;
    return data;
  }
}
