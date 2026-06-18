import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_kishan/features/farmer/inventory/data/inventory_item.dart';
import 'package:smart_kishan/features/farmer/inventory/data/inventory_item_repository.dart';
import 'package:smart_kishan/shared/data/unit_repository.dart';
import 'package:smart_kishan/shared/models/unit.dart';

import 'inventory_state.dart';

class InventoryCubit extends Cubit<InventoryState> {
  InventoryCubit(this._repository, this._unitRepository)
    : super(const InventoryLoading());

  final InventoryItemRepository _repository;
  final UnitRepository _unitRepository;

  List<InventoryItem> get _inventoryItems => state is InventoryLoaded
      ? List.of((state as InventoryLoaded).inventoryItems)
      : [];
  List<Unit> get _units =>
      state is InventoryLoaded ? (state as InventoryLoaded).units : [];

  Future<void> load() async {
    emit(const InventoryLoading());
    try {
      // InventoryItems + units in parallel; units rarely fail but shouldn't block.
      final inventoryItems = await _repository.fetchInventoryItems();
      List<Unit> units = [];
      try {
        units = await _unitRepository.getUnits();
      } catch (e) {
        debugPrint('Units load failed: $e');
      }
      emit(InventoryLoaded(inventoryItems: inventoryItems, units: units));
    } catch (e) {
      debugPrint('Inventory load failed: $e');
      emit(const InventoryFailure());
    }
  }

  Future<bool> add(InventoryItem inventoryItem) async {
    try {
      final created = await _repository.addInventoryItem(inventoryItem);
      emit(
        InventoryLoaded(
          inventoryItems: [..._inventoryItems, created],
          units: _units,
        ),
      );
      return true;
    } catch (e) {
      debugPrint('InventoryItem add failed: $e');
      return false;
    }
  }

  Future<bool> update(InventoryItem inventoryItem) async {
    try {
      final updated = await _repository.updateInventoryItem(inventoryItem);
      final list = _inventoryItems
          .map((p) => p.id == updated.id ? updated : p)
          .toList();
      emit(InventoryLoaded(inventoryItems: list, units: _units));
      return true;
    } catch (e) {
      debugPrint('InventoryItem update failed: $e');
      return false;
    }
  }

  Future<bool> delete(int id) async {
    try {
      await _repository.deleteInventoryItem(id);
      emit(
        InventoryLoaded(
          inventoryItems: _inventoryItems.where((p) => p.id != id).toList(),
          units: _units,
        ),
      );
      return true;
    } catch (e) {
      debugPrint('InventoryItem delete failed: $e');
      return false;
    }
  }
}
