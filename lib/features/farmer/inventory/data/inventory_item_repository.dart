import 'package:smart_kishan/core/constants/api_endpoints.dart';
import 'package:smart_kishan/core/network/api_client.dart';

import 'inventory_item.dart';

/// CRUD over /inventoryItems + the /units lookup. Returns parsed models; the cubit
/// owns list state.
class InventoryItemRepository {
  InventoryItemRepository({required ApiClient api}) : _api = api;

  final ApiClient _api;

  Future<List<InventoryItem>> fetchInventoryItems() async {
    final res = await _api.get(ApiEndpoints.inventoryItems);
    final list = (res.data as List?) ?? const [];
    return list
        .map((e) => InventoryItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<InventoryItem> addInventoryItem(InventoryItem inventoryItem) async {
    final res = await _api.post(
      ApiEndpoints.inventoryItems,
      body: inventoryItem.toJson(),
    );
    return InventoryItem.fromJson(res.data as Map<String, dynamic>);
  }

  Future<InventoryItem> updateInventoryItem(InventoryItem inventoryItem) async {
    final res = await _api.put(
      ApiEndpoints.inventoryItem(inventoryItem.id!),
      body: inventoryItem.toJson(),
    );
    return InventoryItem.fromJson(res.data as Map<String, dynamic>);
  }

  Future<void> deleteInventoryItem(int id) {
    return _api.delete(ApiEndpoints.inventoryItem(id));
  }
}
