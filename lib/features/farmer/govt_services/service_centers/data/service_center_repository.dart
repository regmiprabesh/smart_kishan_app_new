import 'package:smart_kishan/core/network/api_client.dart';

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

class ServiceCenterRepository {
  ServiceCenterRepository({required this.api});

  final ApiClient api;

  static const _base = '/service-centers';

  /// GET /service-centers/types
  Future<List<ServiceCenterType>> fetchTypes() async {
    final res = await api.get('$_base/types');
    final data = res.data as List? ?? const [];
    return data
        .map(
          (e) =>
              ServiceCenterType.fromJson(Map<String, dynamic>.from(e as Map)),
        )
        .toList();
  }

  /// GET /service-centers (with filter/sort/search/location params)
  Future<List<ServiceCenter>> fetchServiceCenters(
    ServiceCenterQuery query,
  ) async {
    final res = await api.get(_base, query: query.toParams());
    final data = res.data as List? ?? const [];
    return data
        .map((e) => ServiceCenter.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  /// GET /service-centers/nearby?latitude=&longitude=&radius=
  Future<List<ServiceCenter>> fetchNearby({
    required double latitude,
    required double longitude,
    double radius = 20,
  }) async {
    final res = await api.get(
      '$_base/nearby',
      query: {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'radius': radius.toString(),
      },
    );
    final data = res.data as List? ?? const [];
    return data
        .map((e) => ServiceCenter.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  /// GET /service-centers/{id}
  Future<ServiceCenter> fetchServiceCenter(int id) async {
    final res = await api.get('$_base/$id');
    return ServiceCenter.fromJson(Map<String, dynamic>.from(res.data as Map));
  }

  /// POST /service-centers/{id}/rate — returns the saved rating so the cubit
  /// can update local state without refetching the whole center.
  Future<ServiceCenterRating> rate({
    required int serviceCenterId,
    required int rating,
    String? review,
  }) async {
    final res = await api.post(
      '$_base/$serviceCenterId/rate',
      body: {'rating': rating, 'review': review},
    );
    return ServiceCenterRating.fromJson(
      Map<String, dynamic>.from(res.data as Map),
    );
  }

  /// GET /service-centers/{id}/my-rating
  Future<ServiceCenterRating?> fetchUserRating(int serviceCenterId) async {
    final res = await api.get('$_base/$serviceCenterId/my-rating');
    if (res.data == null) return null;
    return ServiceCenterRating.fromJson(
      Map<String, dynamic>.from(res.data as Map),
    );
  }

  /// DELETE /service-centers/{id}/my-rating
  Future<void> deleteRating(int serviceCenterId) async {
    await api.delete('$_base/$serviceCenterId/my-rating');
  }
}
