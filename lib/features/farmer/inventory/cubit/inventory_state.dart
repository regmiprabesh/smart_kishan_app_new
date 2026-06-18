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
  const InventoryLoaded({required this.inventoryItems, required this.units});
  final List<InventoryItem> inventoryItems;
  final List<Unit> units;
  @override
  List<Object?> get props => [inventoryItems, units];
}

class InventoryFailure extends InventoryState {
  const InventoryFailure();
}
