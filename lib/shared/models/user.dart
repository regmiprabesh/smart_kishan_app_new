import 'dart:convert';

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
  String? address;
  int? governmentUnitId;

  // For prefilling - computed properties
  String? get fullName => name;
  String? get phoneNumber => phone;
  String? get emailAddress => email;

  String? get fullAddress =>
      (address != null && address!.isNotEmpty) ? address : null;

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
    this.governmentUnitId,
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
    address = json['address'];
    governmentUnitId = json['government_unit_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['parent_id'] = parentId;
    data['password'] = password;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['image'] = image;
    data['address'] = address;
    data['government_unit_id'] = governmentUnitId;
    return data;
  }
}
