import 'package:dio/dio.dart';
import 'package:smart_kishan/core/config/env.dart';
import 'package:smart_kishan/core/constants/api_endpoints.dart';
import 'package:smart_kishan/features/farmer/weather/data/weather_model.dart';

/// OpenWeatherMap access. Uses its own [Dio] (different host + no auth header)
/// rather than the app ApiClient. URLs live in [ApiEndpoints]; the API key
/// comes from .env; the caller supplies coordinates (via LocationService).
class WeatherRepository {
  WeatherRepository({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  Future<Weather> current({required double lat, required double lng}) async {
    final res = await _dio.get(
      ApiEndpoints.owmCurrentWeather,
      queryParameters: {
        'lat': lat,
        'lon': lng,
        'appid': Env.owmApiKey,
        'units': 'metric',
      },
    );
    return Weather.fromJson(res.data as Map<String, dynamic>);
  }

  /// True if rain appears in today's forecast slots.
  Future<bool> willRainToday({required double lat, required double lng}) async {
    final res = await _dio.get(
      ApiEndpoints.owmForecast,
      queryParameters: {
        'lat': lat,
        'lon': lng,
        'appid': Env.owmApiKey,
        'units': 'metric',
      },
    );
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final list = (res.data['list'] as List?) ?? [];
    return list.any(
      (item) =>
          (item['dt_txt'] as String?)?.startsWith(today) == true &&
          item['weather'][0]['main'] == 'Rain',
    );
  }
}
