import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

import '../data/service_center.dart';
import '../data/service_center_repository.dart';

enum ServiceCenterView { list, map }

sealed class ServiceCenterListState extends Equatable {
  const ServiceCenterListState();
  @override
  List<Object?> get props => [];
}

class ServiceCenterListLoading extends ServiceCenterListState {
  const ServiceCenterListLoading();
}

class ServiceCenterListFailure extends ServiceCenterListState {
  const ServiceCenterListFailure(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

/// The working state for the list+map screen. Carries everything the two views
/// share: the loaded centers, available types (for the filter), the active
/// query, the user's location, the current view toggle, and — for the map —
/// the selected marker + its route polyline.
class ServiceCenterListLoaded extends ServiceCenterListState {
  const ServiceCenterListLoaded({
    required this.centers,
    required this.types,
    required this.query,
    this.userLocation,
    this.view = ServiceCenterView.list,
    this.selectedId,
    this.routePoints = const [],
    this.routeLoading = false,
    this.refreshing = false,
  });

  final List<ServiceCenter> centers;
  final List<ServiceCenterType> types;
  final ServiceCenterQuery query;
  final LatLng? userLocation;
  final ServiceCenterView view;

  /// Currently selected center on the map (drives bigger marker + route).
  final int? selectedId;
  final List<LatLng> routePoints;
  final bool routeLoading;

  /// True while a filtered re-fetch is in flight (keeps current list visible).
  final bool refreshing;

  ServiceCenter? get selected =>
      selectedId == null ? null : centers.where((c) => c.id == selectedId).firstOrNull;

  ServiceCenterListLoaded copyWith({
    List<ServiceCenter>? centers,
    List<ServiceCenterType>? types,
    ServiceCenterQuery? query,
    LatLng? userLocation,
    ServiceCenterView? view,
    int? selectedId,
    bool clearSelected = false,
    List<LatLng>? routePoints,
    bool? routeLoading,
    bool? refreshing,
  }) {
    return ServiceCenterListLoaded(
      centers: centers ?? this.centers,
      types: types ?? this.types,
      query: query ?? this.query,
      userLocation: userLocation ?? this.userLocation,
      view: view ?? this.view,
      selectedId: clearSelected ? null : (selectedId ?? this.selectedId),
      routePoints: routePoints ?? this.routePoints,
      routeLoading: routeLoading ?? this.routeLoading,
      refreshing: refreshing ?? this.refreshing,
    );
  }

  @override
  List<Object?> get props => [
        centers,
        types,
        query,
        userLocation,
        view,
        selectedId,
        routePoints,
        routeLoading,
        refreshing,
      ];
}
