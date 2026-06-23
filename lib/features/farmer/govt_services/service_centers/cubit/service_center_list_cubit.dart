import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:smart_kishan/core/services/location_service.dart';
import 'package:smart_kishan/core/services/routing_service.dart';

import '../data/service_center.dart';
import '../data/service_center_repository.dart';
import 'service_center_list_state.dart';

class ServiceCenterListCubit extends Cubit<ServiceCenterListState> {
  ServiceCenterListCubit(this._repo, this._location, this._routing)
    : super(const ServiceCenterListLoading());

  final ServiceCenterRepository _repo;
  final LocationService _location;
  final RoutingService _routing;

  /// Initial load: resolve location, then fetch types + centers in parallel.
  Future<void> load() async {
    emit(const ServiceCenterListLoading());
    try {
      final loc = await _location.currentLatLng();
      final query = ServiceCenterQuery(
        latitude: loc.lat,
        longitude: loc.lng,
        sortBy: 'distance',
      );
      final results = await Future.wait([
        _repo.fetchTypes(),
        _repo.fetchServiceCenters(query),
      ]);
      emit(
        ServiceCenterListLoaded(
          centers: results[1] as List<ServiceCenter>,
          types: results[0] as List<ServiceCenterType>,
          query: query,
          userLocation: LatLng(loc.lat, loc.lng),
        ),
      );
    } catch (e) {
      emit(ServiceCenterListFailure(e.toString()));
    }
  }

  /// Re-fetch with a new query, keeping the existing list visible meanwhile.
  Future<void> _applyQuery(ServiceCenterQuery query) async {
    final s = state;
    if (s is! ServiceCenterListLoaded) return;
    emit(
      s.copyWith(
        query: query,
        refreshing: true,
        clearSelected: true,
        routePoints: [],
      ),
    );
    try {
      final centers = await _repo.fetchServiceCenters(query);
      // Re-read latest state in case the view toggled mid-flight.
      final cur = state;
      if (cur is ServiceCenterListLoaded) {
        emit(cur.copyWith(centers: centers, refreshing: false));
      }
    } catch (_) {
      final cur = state;
      if (cur is ServiceCenterListLoaded) {
        emit(cur.copyWith(refreshing: false));
      }
    }
  }

  /// Patch one center's rating aggregate in place — no refetch. Called when a
  /// rating made on the detail screen reports the new server aggregate, so the
  /// card reflects it immediately.
  void updateAggregate(int id, double average, int total) {
    final s = state;
    if (s is! ServiceCenterListLoaded) return;
    emit(
      s.copyWith(
        centers: [
          for (final c in s.centers)
            c.id == id
                ? c.copyWith(averageRating: average, totalRatings: total)
                : c,
        ],
      ),
    );
  }

  ///Refresh
  Future<void> refresh() async {
    final s = state;
    if (s is ServiceCenterListLoaded) {
      _applyQuery(s.query);
    } else {
      load();
    }
  }

  void search(String text) {
    final s = state;
    if (s is! ServiceCenterListLoaded) return;
    _applyQuery(s.query.copyWith(search: text));
  }

  void setType(int? typeId) {
    final s = state;
    if (s is! ServiceCenterListLoaded) return;
    _applyQuery(
      typeId == null
          ? s.query.copyWith(clearType: true)
          : s.query.copyWith(typeId: typeId),
    );
  }

  void setSortBy(String sortBy) {
    final s = state;
    if (s is! ServiceCenterListLoaded) return;
    _applyQuery(s.query.copyWith(sortBy: sortBy));
  }

  void setRadius(double radius) {
    final s = state;
    if (s is! ServiceCenterListLoaded) return;
    _applyQuery(s.query.copyWith(radius: radius));
  }

  void setFeaturedOnly(bool value) {
    final s = state;
    if (s is! ServiceCenterListLoaded) return;
    _applyQuery(s.query.copyWith(featuredOnly: value));
  }

  /// Apply several filter changes at once (from the filter sheet's "Apply").
  void applyFilters({
    int? typeId,
    bool clearType = false,
    String? sortBy,
    double? radius,
    bool? featuredOnly,
  }) {
    final s = state;
    if (s is! ServiceCenterListLoaded) return;
    _applyQuery(
      s.query.copyWith(
        typeId: typeId,
        clearType: clearType,
        sortBy: sortBy,
        radius: radius,
        featuredOnly: featuredOnly,
      ),
    );
  }

  void clearFilters() {
    final s = state;
    if (s is! ServiceCenterListLoaded) return;
    _applyQuery(
      ServiceCenterQuery(
        latitude: s.query.latitude,
        longitude: s.query.longitude,
        sortBy: 'distance',
      ),
    );
  }

  void toggleView(ServiceCenterView view) {
    final s = state;
    if (s is! ServiceCenterListLoaded) return;
    emit(s.copyWith(view: view, clearSelected: true, routePoints: []));
  }

  /// Map marker tapped: select it and fetch a driving route from the user.
  Future<void> selectCenter(ServiceCenter center) async {
    final s = state;
    if (s is! ServiceCenterListLoaded) return;
    emit(
      s.copyWith(selectedId: center.id, routeLoading: true, routePoints: []),
    );

    final from = s.userLocation;
    if (from == null) {
      emit(s.copyWith(selectedId: center.id, routeLoading: false));
      return;
    }
    final route = await _routing.getRoute(
      from,
      LatLng(center.latitude, center.longitude),
    );
    final cur = state;
    if (cur is ServiceCenterListLoaded && cur.selectedId == center.id) {
      emit(cur.copyWith(routePoints: route ?? const [], routeLoading: false));
    }
  }

  void clearSelection() {
    final s = state;
    if (s is! ServiceCenterListLoaded) return;
    emit(s.copyWith(clearSelected: true, routePoints: []));
  }
}
