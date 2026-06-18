import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_kishan/core/services/location_service.dart';
import 'package:smart_kishan/features/farmer/weather/cubit/weather_state.dart';
import 'package:smart_kishan/features/farmer/weather/data/weather_repository.dart';

/// Loads current weather + today's rain advisory once, caches in state.
/// Resolves the user's location via [LocationService] (which falls back to
/// MapConstants.fallbackCenter when GPS is unavailable). Failure is
/// silent-ish (the card just hides) since weather is non-critical.
class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit(this._repository, this._locationService)
    : super(const WeatherLoading());

  final WeatherRepository _repository;
  final LocationService _locationService;

  Future<void> load() async {
    emit(const WeatherLoading());
    try {
      final loc = await _locationService.currentLatLng();
      final weather = await _repository.current(lat: loc.lat, lng: loc.lng);
      bool rain = false;
      try {
        rain = await _repository.willRainToday(lat: loc.lat, lng: loc.lng);
      } catch (e) {
        debugPrint('Forecast failed (advisory hidden): $e');
      }
      emit(WeatherLoaded(weather: weather, willRainToday: rain));
    } catch (e) {
      debugPrint('Weather load failed: $e');
      emit(const WeatherFailure());
    }
  }
}
