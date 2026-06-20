import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_kishan/features/farmer/daily_activity/cubit/daily_activity_state.dart';
import 'package:smart_kishan/features/farmer/daily_activity/data/activity.dart';
import 'package:smart_kishan/features/farmer/daily_activity/data/activity_repository.dart';
import 'package:smart_kishan/features/farmer/inventory/data/inventory_item_repository.dart';

/// Owns the activity list + the inventoryItem list (for Buy/Sell dropdowns).
/// InventoryItems come from the inventory repository fetched on load — NOT cached
/// like units, because inventoryItems are mutable user data and we want current
/// stock. Mutations are optimistic; each returns a bool for the form.
class DailyActivityCubit extends Cubit<DailyActivityState> {
  DailyActivityCubit(this._repository, this._inventoryItemRepository)
    : super(const DailyActivityLoading());

  final ActivityRepository _repository;
  final InventoryItemRepository _inventoryItemRepository;
  String _query = '';

  List<Activity> get _activities => state is DailyActivityLoaded
      ? List.of((state as DailyActivityLoaded).activities)
      : [];
  List get _inventoryItems => state is DailyActivityLoaded
      ? (state as DailyActivityLoaded).inventoryItems
      : [];

  Future<void> load() async {
    emit(const DailyActivityLoading());
    await Future.delayed(Duration(seconds: 30));
    try {
      final activities = await _repository.fetchActivities();
      var inventoryItems = _inventoryItems;
      try {
        inventoryItems = await _inventoryItemRepository
            .fetchInventoryItems(); // your method
      } catch (e) {
        debugPrint('InventoryItems for activity dropdown failed: $e');
      }
      emit(
        DailyActivityLoaded(
          activities: activities,
          inventoryItems: inventoryItems.cast(),
          query: _query,
        ),
      );
    } catch (e) {
      debugPrint('Activities load failed: $e');
      emit(const DailyActivityFailure());
    }
  }

  Future<bool> add(Activity activity) async {
    try {
      final created = await _repository.addActivity(activity);
      emit(
        DailyActivityLoaded(
          activities: [created, ..._activities],
          inventoryItems: _inventoryItems.cast(),
          query: _query,
        ),
      );
      return true;
    } catch (e) {
      debugPrint('Activity add failed: $e');
      return false;
    }
  }

  Future<bool> update(Activity activity) async {
    try {
      final updated = await _repository.updateActivity(activity);
      final list = _activities
          .map((a) => a.id == updated.id ? updated : a)
          .toList();
      emit(
        DailyActivityLoaded(
          activities: list,
          inventoryItems: _inventoryItems.cast(),
          query: _query,
        ),
      );
      return true;
    } catch (e) {
      debugPrint('Activity update failed: $e');
      return false;
    }
  }

  Future<bool> delete(int id) async {
    try {
      await _repository.deleteActivity(id);
      emit(
        DailyActivityLoaded(
          activities: _activities.where((a) => a.id != id).toList(),
          inventoryItems: _inventoryItems.cast(),
          query: _query,
        ),
      );
      return true;
    } catch (e) {
      debugPrint('Activity delete failed: $e');
      return false;
    }
  }

  void search(String query) {
    final s = state;
    _query = query;
    if (s is DailyActivityLoaded) emit(s.copyWith(query: query));
  }

  List<Activity> filtered(DailyActivityLoaded state) {
    final q = state.query.trim().toLowerCase();
    if (q.isEmpty) return state.activities;
    return state.activities
        .where(
          (a) =>
              (a.title ?? '').toLowerCase().contains(q) ||
              (a.description ?? '').toLowerCase().contains(q),
        )
        .toList();
  }
}
