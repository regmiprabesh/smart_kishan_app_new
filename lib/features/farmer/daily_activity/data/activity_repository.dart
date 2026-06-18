import 'package:smart_kishan/core/constants/api_endpoints.dart';
import 'package:smart_kishan/core/network/api_client.dart';
import 'package:smart_kishan/features/farmer/daily_activity/data/activity.dart';

/// CRUD over /activities. ApiClient unwraps the `data` envelope.
class ActivityRepository {
  ActivityRepository({required ApiClient api}) : _api = api;

  final ApiClient _api;

  Future<List<Activity>> fetchActivities() async {
    final res = await _api.get(ApiEndpoints.activities);
    final list = (res.data as List?) ?? const [];
    return list
        .map((e) => Activity.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Activity> addActivity(Activity activity) async {
    final res = await _api.post(
      ApiEndpoints.activities,
      body: activity.toJson(),
    );
    return Activity.fromJson(res.data as Map<String, dynamic>);
  }

  Future<Activity> updateActivity(Activity activity) async {
    final res = await _api.put(
      ApiEndpoints.activity(activity.id!),
      body: activity.toJson(),
    );
    return Activity.fromJson(res.data as Map<String, dynamic>);
  }

  Future<void> deleteActivity(int id) {
    return _api.delete(ApiEndpoints.activity(id));
  }
}
