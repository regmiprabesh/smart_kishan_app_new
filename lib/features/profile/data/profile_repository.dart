import 'package:smart_kishan/core/constants/api_endpoints.dart';
import 'package:smart_kishan/core/network/api_client.dart';
import 'package:smart_kishan/core/services/local_storage_service.dart';
import 'package:smart_kishan/shared/models/user.dart';

/// Profile data ops on top of ApiClient. Updates the cached user after a
/// successful change so the UI reflects it without a full refetch.
class ProfileRepository {
  ProfileRepository({
    required ApiClient api,
    required LocalStorageService storage,
  }) : _api = api,
       _storage = storage;

  final ApiClient _api;
  final LocalStorageService _storage;

  Future<User> updateProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    final res = await _api.put(
      ApiEndpoints.updateProfile,
      body: {'name': name, 'email': email, 'phone': phone},
    );
    return _cacheUser(res.data as Map<String, dynamic>);
  }

  Future<User> uploadProfileImage(String imagePath) async {
    final res = await _api.postMultipart(
      ApiEndpoints.uploadProfileImage,
      files: {'image': imagePath},
    );
    return _cacheUser(res.data as Map<String, dynamic>);
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) {
    return _api.post(
      ApiEndpoints.changePassword,
      body: {
        'current_password': currentPassword,
        'password': newPassword,
        'password_confirmation': newPasswordConfirmation,
      },
    );
  }

  Future<User> updateLocation({
    required int provinceId,
    required int districtId,
    required int municipalityId,
    required int wardId,
  }) async {
    final res = await _api.post(
      ApiEndpoints.updateLocation,
      body: {
        'province_id': provinceId,
        'district_id': districtId,
        'municipality_id': municipalityId,
        'ward_id': wardId,
      },
    );
    return _cacheUser(res.data as Map<String, dynamic>);
  }

  /// Server returns the updated user under `data` (or `data.user`); persist
  /// it so the cached session matches.
  Future<User> _cacheUser(Map<String, dynamic> data) async {
    final userJson = (data['user'] as Map<String, dynamic>?) ?? data;
    await _storage.saveUser(userJson);
    return User.fromJson(userJson);
  }
}
