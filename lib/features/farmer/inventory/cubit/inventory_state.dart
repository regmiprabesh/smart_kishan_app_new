import 'package:equatable/equatable.dart';
import 'package:smart_kishan/features/farmer/inventory/data/inventory_item.dart';
import 'package:smart_kishan/shared/models/unit.dart';

sealed class InventoryState extends Equatable {
  const InventoryState();
  @override
  List<Object?> get props => [];
}

class InventoryLoading extends InventoryState {
  const InventoryLoading();
}

class InventoryLoaded extends InventoryState {
  const InventoryLoaded({
    required this.inventoryItems,
    required this.units,
    this.query = '',
  });
  final List<InventoryItem> inventoryItems;
  final List<Unit> units;
  final String query;
  InventoryLoaded copyWith({
    List<InventoryItem>? inventoryItems,
    List<Unit>? units,
    String? query,
  }) => InventoryLoaded(
    inventoryItems: inventoryItems ?? this.inventoryItems,
    units: units ?? this.units,
    query: query ?? this.query,
  );
  @override
  List<Object?> get props => [inventoryItems, units, query];
}

class InventoryFailure extends InventoryState {
  const InventoryFailure();
}
