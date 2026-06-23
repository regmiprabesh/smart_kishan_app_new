import 'package:smart_kishan/core/constants/api_endpoints.dart';
import 'package:smart_kishan/core/network/api_client.dart';
import 'package:smart_kishan/shared/ratings/rating_aggregate.dart';

import 'service_center.dart';

/// Filter/sort options for the list + map query. Mirrors the old
/// getServiceCenters params. `sortBy` values match the backend: distance /
/// name / rating / newest.
class ServiceCenterQuery {
  const ServiceCenterQuery({
    this.typeId,
    this.search,
    this.latitude,
    this.longitude,
    this.radius,
    this.featuredOnly = false,
    this.sortBy = 'distance',
  });

  final int? typeId;
  final String? search;
  final double? latitude;
  final double? longitude;
  final double? radius;
  final bool featuredOnly;
  final String sortBy;

  Map<String, String> toParams() {
    final p = <String, String>{};
    if (typeId != null) p['type_id'] = typeId.toString();
    if (search != null && search!.isNotEmpty) p['search'] = search!;
    if (latitude != null) p['latitude'] = latitude.toString();
    if (longitude != null) p['longitude'] = longitude.toString();
    if (radius != null) p['radius'] = radius.toString();
    if (featuredOnly) p['featured'] = '1';
    p['sort_by'] = sortBy;
    return p;
  }

  ServiceCenterQuery copyWith({
    int? typeId,
    bool clearType = false,
    String? search,
    double? latitude,
    double? longitude,
    double? radius,
    bool? featuredOnly,
    String? sortBy,
  }) {
    return ServiceCenterQuery(
      typeId: clearType ? null : (typeId ?? this.typeId),
      search: search ?? this.search,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radius: radius ?? this.radius,
      featuredOnly: featuredOnly ?? this.featuredOnly,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

/// Service Center CRUD + ratings. Read-only from the farmer app (no
/// add/update/delete here — those live in the admin/Filament backend).
class ServiceCenterRepository {
  ServiceCenterRepository({required ApiClient api}) : _api = api;

  final ApiClient _api;

  /// GET /service-centers/types
  Future<List<ServiceCenterType>> fetchTypes() async {
    final res = await _api.get(ApiEndpoints.serviceCenterTypes);
    final list = (res.data as List?) ?? const [];
    return list
        .map((e) => ServiceCenterType.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET /service-centers (with filter/sort/search/location params)
  Future<List<ServiceCenter>> fetchServiceCenters(
    ServiceCenterQuery query,
  ) async {
    final res = await _api.get(
      ApiEndpoints.serviceCenters,
      query: query.toParams(),
    );
    final list = (res.data as List?) ?? const [];
    return list
        .map((e) => ServiceCenter.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET /service-centers/{id}
  Future<ServiceCenter> fetchServiceCenter(int id) async {
    final res = await _api.get(ApiEndpoints.serviceCenter(id));
    return ServiceCenter.fromJson(res.data as Map<String, dynamic>);
  }

  /// POST /service-centers/{id}/rate — returns the server's recomputed
  /// aggregate so the cubit can adopt the authoritative average/total.
  Future<RatingAggregate> rate({
    required int serviceCenterId,
    required int rating,
    String? review,
  }) async {
    final res = await _api.post(
      ApiEndpoints.serviceCenterRating(serviceCenterId),
      body: {'rating': rating, 'review': review},
    );
    return RatingAggregate.fromJson(res.data as Map<String, dynamic>);
  }

  /// GET /service-centers/{id}/reviews — the full paginated list (mirrors the
  /// subsidy reviews endpoint). The detail screen seeds a capped preview from
  /// `show`; the "See all" page calls this fresh.
  Future<List<ServiceCenterRating>> fetchReviews(
    int serviceCenterId, {
    int page = 1,
  }) async {
    final res = await _api.get(
      ApiEndpoints.serviceCenterReviews(serviceCenterId),
      query: {'page': '$page'},
    );
    // List is nested under data.ratings.data (Laravel paginator); fall back to
    // a bare list in case the shape is ever flattened.
    final payload = res.data;
    final ratings = payload is Map ? payload['ratings'] : payload;
    final items = ratings is Map ? ratings['data'] : ratings;
    final list = (items as List?) ?? const [];
    return list
        .map((e) => ServiceCenterRating.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET /service-centers/{id}/my-rating
  Future<ServiceCenterRating?> fetchUserRating(int serviceCenterId) async {
    final res = await _api.get(
      ApiEndpoints.serviceCenterRating(serviceCenterId),
    );
    if (res.data == null) return null;
    return ServiceCenterRating.fromJson(res.data as Map<String, dynamic>);
  }

  /// DELETE /service-centers/{id}/my-rating — returns the recomputed aggregate.
  Future<RatingAggregate> deleteRating(int serviceCenterId) async {
    final res = await _api.delete(
      ApiEndpoints.serviceCenterRating(serviceCenterId),
    );
    return RatingAggregate.fromJson(res.data as Map<String, dynamic>);
  }
}
