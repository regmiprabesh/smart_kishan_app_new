import 'package:smart_kishan/features/farmer/inventory/cubit/inventory_cubit.dart';
import 'package:smart_kishan/features/farmer/inventory/data/inventory_item.dart';

class InventoryItemArgs {
  const InventoryItemArgs({required this.cubit, this.inventoryItem});
  final InventoryCubit cubit;
  final InventoryItem? inventoryItem;
}
