import 'package:smart_kishan/core/constants/api_endpoints.dart';
import 'package:smart_kishan/core/network/api_client.dart';
import 'package:smart_kishan/core/services/local_storage_service.dart';
import 'package:smart_kishan/shared/models/location.dart';
import 'package:smart_kishan/shared/models/user.dart';

/// Data source for the administrative-location cascade (province → district →
/// municipality → ward) and for persisting the user's chosen location.
///
/// Kept self-contained (it both reads the lookups and writes + caches the
/// updated user) so the Update Location feature needs no other repository.
class LocationRepository {
  LocationRepository({
    required ApiClient api,
    required LocalStorageService storage,
  }) : _api = api,
       _storage = storage;

  final ApiClient _api;
  final LocalStorageService _storage;

  Future<List<Province>> fetchProvinces() async {
    final res = await _api.get(ApiEndpoints.provinces);
    return _list(res.body['provinces'], Province.fromJson);
  }

  Future<List<District>> fetchDistricts(int provinceId) async {
    final res = await _api.get(ApiEndpoints.districts(provinceId));
    return _list(res.body['districts'], District.fromJson);
  }

  Future<List<Municipality>> fetchMunicipalities(int districtId) async {
    final res = await _api.get(ApiEndpoints.municipalities(districtId));
    return _list(res.body['municipalities'], Municipality.fromJson);
  }

  Future<List<Ward>> fetchWards(int municipalityId) async {
    final res = await _api.get(ApiEndpoints.wards(municipalityId));
    return _list(res.body['wards'], Ward.fromJson);
  }

  /// POST /users/update-location, then cache the returned user so the global
  /// session can be refreshed and the app reflects the new location.
  Future<User> updateLocation({
    required int provinceId,
    required int districtId,
    required int municipalityId,
    required int wardId,
    String? address,
  }) async {
    final res = await _api.post(
      ApiEndpoints.updateLocation,
      body: {
        'province_id': provinceId,
        'district_id': districtId,
        'municipality_id': municipalityId,
        'ward_id': wardId,
        if (address != null && address.isNotEmpty) 'address': address,
      },
    );
    // Server wraps the updated user under `data` (sometimes `data.user`);
    // fall back to a top-level `user` / the body itself defensively.
    final raw = (res.data ?? res.body['user'] ?? res.body) as Map;
    final map = Map<String, dynamic>.from(raw);
    final userJson = (map['user'] as Map?) != null
        ? Map<String, dynamic>.from(map['user'] as Map)
        : map;
    await _storage.saveUser(userJson);
    return User.fromJson(userJson);
  }

  List<T> _list<T>(dynamic data, T Function(Map<String, dynamic>) fromJson) {
    final list = (data as List?) ?? const [];
    return list
        .map((e) => fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }
}
