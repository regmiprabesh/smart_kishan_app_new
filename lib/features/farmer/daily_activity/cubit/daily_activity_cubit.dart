import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_kishan/core/network/api_client.dart';
import 'package:smart_kishan/features/farmer/daily_activity/cubit/daily_activity_state.dart';
import 'package:smart_kishan/features/farmer/daily_activity/data/activity.dart';
import 'package:smart_kishan/features/farmer/daily_activity/data/activity_repository.dart';
import 'package:smart_kishan/features/farmer/inventory/data/inventory_item_repository.dart';

/// Outcome of add()/update(): either success, or a failure carrying enough
/// structure for the SCREEN to localize — the cubit has no BuildContext/l10n
/// access, so it can't produce a display string itself. [reasonKey] +
/// [reasonParams] follow the same pattern as the crop-cycle AI suggestions;
/// [fallbackMessage] covers errors that never went through that path (no
/// internet, server error, etc.) and is already in whatever language the
/// server happened to respond in — used only when reasonKey is null.
class ActivitySaveResult {
  const ActivitySaveResult.success()
    : success = true,
      reasonKey = null,
      reasonParams = const {},
      fallbackMessage = null;

  const ActivitySaveResult.failure({
    this.reasonKey,
    this.reasonParams = const {},
    this.fallbackMessage,
  }) : success = false;

  final bool success;
  final String? reasonKey;
  final Map<String, dynamic> reasonParams;
  final String? fallbackMessage;
}

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

  Future<ActivitySaveResult> add(Activity activity) async {
    try {
      final created = await _repository.addActivity(activity);
      emit(
        DailyActivityLoaded(
          activities: [created, ..._activities],
          inventoryItems: _inventoryItems.cast(),
          query: _query,
        ),
      );
      return const ActivitySaveResult.success();
    } catch (e) {
      debugPrint('Activity add failed: $e');
      return _failureFor(e);
    }
  }

  Future<ActivitySaveResult> update(Activity activity) async {
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
      return const ActivitySaveResult.success();
    } catch (e) {
      debugPrint('Activity update failed: $e');
      return _failureFor(e);
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

  /// Builds the localizable failure for add()/update(). Tries to parse a
  /// {reason_key, reason_params} JSON payload out of a validation error
  /// first (server-encoded, language-agnostic); falls back to whatever
  /// plain message the exception carries for anything that isn't in that
  /// shape (no internet, server error, an unrelated validation message).
  ActivitySaveResult _failureFor(Object e) {
    if (e is ValidationException) {
      final errors = e.errors;
      final firstField = errors != null && errors.isNotEmpty
          ? errors.values.first
          : null;
      final raw = firstField is List && firstField.isNotEmpty
          ? firstField.first.toString()
          : firstField?.toString();

      if (raw != null) {
        try {
          final decoded = jsonDecode(raw);
          if (decoded is Map && decoded['reason_key'] != null) {
            return ActivitySaveResult.failure(
              reasonKey: decoded['reason_key'] as String,
              reasonParams: Map<String, dynamic>.from(
                decoded['reason_params'] as Map? ?? const {},
              ),
            );
          }
        } catch (_) {
          // Not our structured payload — fall through to plain text below.
        }
        return ActivitySaveResult.failure(fallbackMessage: raw);
      }
      return ActivitySaveResult.failure(fallbackMessage: e.message);
    }
    if (e is ApiException) {
      return ActivitySaveResult.failure(fallbackMessage: e.message);
    }
    return const ActivitySaveResult.failure();
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
