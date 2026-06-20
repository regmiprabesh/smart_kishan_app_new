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
    this.query = '',
  });
  final List<Activity> activities;
  final List<InventoryItem> inventoryItems;
  final String query;
  DailyActivityLoaded copyWith({
    List<Activity>? activities,
    List<InventoryItem>? inventoryItems,
    String? query,
  }) => DailyActivityLoaded(
    activities: activities ?? this.activities,
    inventoryItems: inventoryItems ?? this.inventoryItems,
    query: query ?? this.query,
  );
  @override
  List<Object?> get props => [activities, inventoryItems, query];
}

class DailyActivityFailure extends DailyActivityState {
  const DailyActivityFailure();
}
