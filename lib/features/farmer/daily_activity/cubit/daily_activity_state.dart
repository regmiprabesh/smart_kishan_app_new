import 'package:equatable/equatable.dart';
import 'package:smart_kishan/features/farmer/daily_activity/data/activity.dart';
import 'package:smart_kishan/features/farmer/inventory/data/inventory_item.dart';

sealed class DailyActivityState extends Equatable {
  const DailyActivityState();
  @override
  List<Object?> get props => [];
}

class DailyActivityLoading extends DailyActivityState {
  const DailyActivityLoading();
}

class DailyActivityLoaded extends DailyActivityState {
  const DailyActivityLoaded({
    required this.activities,
    required this.inventoryItems,
  });

  final List<Activity> activities;

  /// InventoryItems for the Buy/Sell inventoryItem dropdown (from inventory).
  final List<InventoryItem> inventoryItems;

  @override
  List<Object?> get props => [activities, inventoryItems];
}

class DailyActivityFailure extends DailyActivityState {
  const DailyActivityFailure();
}
