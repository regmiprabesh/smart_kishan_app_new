import 'package:smart_kishan/core/constants/api_endpoints.dart';
import 'package:smart_kishan/core/network/api_client.dart';
import 'crop_info.dart';

/// Fetches crop reference info from the backend. Static-ish data (changes
/// rarely), so it's a good candidate for caching like Units later.
class CropInfoRepository {
  CropInfoRepository({required ApiClient api}) : _api = api;
  final ApiClient _api;

  Future<List<CropInfo>> fetchCrops() async {
    final res = await _api.get(ApiEndpoints.crops);
    final list = (res.data as List?) ?? const [];
    return list
        .map((e) => CropInfo.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
