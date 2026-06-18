import 'package:smart_kishan/shared/models/unit.dart';

class InventoryItem {
  const InventoryItem({
    this.id,
    this.name,
    this.stock,
    this.unitId,
    this.unit,
    this.description,
    this.isSellable,
    this.userId,
    this.createdAt,
  });

  final int? id;
  final String? name;
  final int? stock;
  final int? unitId;
  final Unit? unit;
  final String? description;
  final int? isSellable;
  final int? userId;
  final String? createdAt;

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'] as int?,
      name: json['name'] as String?,
      stock: json['stock'] is int
          ? json['stock'] as int
          : int.tryParse('${json['stock']}'),
      unitId: json['unit_id'] as int?,
      unit: json['unit'] != null
          ? Unit.fromJson(json['unit'] as Map<String, dynamic>)
          : null,
      description: json['description'] as String?,
      isSellable: json['is_sellable'] as int?,
      userId: json['user_id'] as int?,
      createdAt: json['created_at'] as String?,
    );
  }

  /// Body for create/update (server assigns id/user/date).
  Map<String, dynamic> toJson() => {
    'name': name,
    'stock': stock,
    'unit_id': unitId,
    'description': description,
    'is_sellable': isSellable,
  };

  InventoryItem copyWith({int? stock, String? name}) => InventoryItem(
    id: id,
    name: name ?? this.name,
    stock: stock ?? this.stock,
    unitId: unitId,
    unit: unit,
    description: description,
    isSellable: isSellable,
    userId: userId,
    createdAt: createdAt,
  );
}
