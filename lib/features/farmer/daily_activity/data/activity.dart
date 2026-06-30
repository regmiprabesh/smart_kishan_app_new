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
    this.adjustStock = false,
    this.stockAdjusted = false,
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

  /// Set on a create/update request to opt in to a stock change for this
  /// save. Not persisted by the server under this name — see [stockAdjusted].
  final bool adjustStock;

  /// Read back from the server: whether THIS activity's last save actually
  /// moved inventory stock. Source of truth for displaying "stock was
  /// adjusted" in the UI; has no bearing on what a future save will do.
  final bool stockAdjusted;

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
      inventoryItemId: json['inventory_item_id'] as int?,
      quantity: json['quantity'] as int?,
      userId: json['user_id'] as int?,
      date: json['created_at'] as String?,
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      stockAdjusted: json['stock_adjusted'] as bool? ?? false,
    );
  }

  /// Body for create/update. `adjust_stock` is always sent explicitly — the
  /// API requires it (no implicit default), so the caller must always state
  /// whether this save should move inventory stock.
  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'type': type,
    'expense_amount': expense,
    'income_amount': income,
    'inventory_item_id': inventoryItemId,
    'quantity': quantity,
    'adjust_stock': adjustStock,
  };
}
