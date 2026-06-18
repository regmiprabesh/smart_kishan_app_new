import 'package:smart_kishan/core/constants/api_endpoints.dart';
import 'package:smart_kishan/core/network/api_client.dart';
import 'farmland.dart';
import 'soil_data.dart';

/// Farmland CRUD. Create/update use multipart (image upload). The backend's
/// update is a POST to /farmlands/update/{id} (multipart can't be PUT), so we
/// keep that route. ApiClient unwraps the `data` envelope.
class FarmlandRepository {
  FarmlandRepository({required ApiClient api}) : _api = api;

  final ApiClient _api;

  Future<List<Farmland>> fetchFarmlands() async {
    final res = await _api.get(ApiEndpoints.farmlands);
    final list = (res.data as List?) ?? const [];
    return list
        .map((e) => Farmland.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Farmland> addFarmland(
    Farmland farmland, {
    String? imagePath,
    void Function(int, int)? onSendProgress,
  }) async {
    final res = await _api.postMultipart(
      ApiEndpoints.farmlands,
      fields: _stringFields(farmland.toFormData()),
      files: imagePath != null ? {'image': imagePath} : const {},
      onSendProgress: onSendProgress,
    );
    return Farmland.fromJson(res.data as Map<String, dynamic>);
  }

  Future<Farmland> updateFarmland(
    Farmland farmland, {
    String? imagePath,
    bool removeImage = false, // ← new param
    void Function(int, int)? onSendProgress,
  }) async {
    final res = await _api.postMultipart(
      ApiEndpoints.farmland(farmland.id!),
      fields: {
        ..._stringFields(farmland.toFormData()),
        '_method': 'PUT',
        if (removeImage && imagePath == null) 'remove_image': '1',
      },
      files: imagePath != null ? {'image': imagePath} : const {},
      onSendProgress: onSendProgress,
    );
    return Farmland.fromJson(res.data as Map<String, dynamic>);
  }

  Future<void> deleteFarmland(int id) {
    return _api.delete(ApiEndpoints.farmland(id));
  }

  Future<SoilData?> fetchSoil(double lat, double lng) async {
    // Backend proxy → returns the soil object inside our {success,message,data}
    // envelope, so read res.data (NOT res.body).
    final res = await _api.get(
      ApiEndpoints.farmlandSoil,
      query: {'lat': '$lat', 'lng': '$lng'},
    );
    final data = res.data;
    if (data is Map<String, dynamic>) return SoilData.fromJson(data);
    return null;
  }

  // Multipart fields must be String; drop nulls, stringify the rest.
  Map<String, String> _stringFields(Map<String, dynamic> data) => {
    for (final e in data.entries)
      if (e.value != null) e.key: e.value.toString(),
  };
}
