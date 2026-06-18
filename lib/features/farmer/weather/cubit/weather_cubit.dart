import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_kishan/features/farmer/weather/cubit/weather_state.dart';
import 'package:smart_kishan/features/farmer/weather/data/weather_repository.dart';

/// Loads current weather + today's rain advisory once, caches in state.
/// Used by the farmer home's WeatherCard. Failure is silent-ish (the card
/// just hides) since weather is non-critical.
class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit(this._repository) : super(const WeatherLoading());

  final WeatherRepository _repository;

  Future<void> load() async {
    emit(const WeatherLoading());
    try {
      // Fetch both in parallel; rain advisory failure shouldn't block temp.
      final weather = await _repository.current();
      bool rain = false;
      try {
        rain = await _repository.willRainToday();
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
