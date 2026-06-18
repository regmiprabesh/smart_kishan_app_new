import 'package:smart_kishan/shared/models/user.dart';

class Activity {
  const Activity({
    this.id,
    this.title,
    this.description,
    this.type,
    this.expense,
    this.income,
    this.inventoryItemId,
    this.quantity,
    this.userId,
    this.date,
    this.user,
  });

  final int? id;
  final String? title;
  final String? description;
  final String? type; // 'Buy' | 'Sell' | 'Other'
  final double? expense;
  final double? income;
  final int? inventoryItemId;
  final int? quantity;
  final int? userId;
  final String? date;
  final User? user;

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] as int?,
      title: json['title'] as String?,
      description: json['description'] as String? ?? '',
      type: json['type'] as String?,
      expense: json['expense_amount'] != null
          ? double.tryParse(json['expense_amount'].toString())
          : null,
      income: json['income_amount'] != null
          ? double.tryParse(json['income_amount'].toString())
          : null,
      inventoryItemId: json['product_id'] as int?,
      quantity: json['quantity'] as int?,
      userId: json['user_id'] as int?,
      date: json['created_at'] as String?,
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Body for create/update.
  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'type': type,
    'expense_amount': expense,
    'income_amount': income,
    'product_id': inventoryItemId,
    'quantity': quantity,
  };
}
