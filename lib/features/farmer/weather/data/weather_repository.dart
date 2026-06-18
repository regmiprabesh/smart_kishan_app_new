import 'package:dio/dio.dart';
import 'package:smart_kishan/core/config/env.dart';
import 'package:smart_kishan/features/farmer/weather/data/weather_model.dart';

/// OpenWeatherMap access. Separate Dio (different base URL + no auth header)
/// from the app ApiClient. Key + default coords come from .env.
class WeatherRepository {
  WeatherRepository({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  static const _base = 'https://api.openweathermap.org/data/2.5';
  static const _lat = 27.7172; // Kathmandu fallback
  static const _lng = 85.3240;

  Future<Weather> current() async {
    final res = await _dio.get(
      '$_base/weather',
      queryParameters: {
        'lat': _lat,
        'lon': _lng,
        'appid': Env.owmApiKey,
        'units': 'metric',
      },
    );
    return Weather.fromJson(res.data as Map<String, dynamic>);
  }

  /// True if rain appears in today's forecast slots.
  Future<bool> willRainToday() async {
    final res = await _dio.get(
      '$_base/forecast',
      queryParameters: {
        'lat': _lat,
        'lon': _lng,
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
