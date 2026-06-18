import 'package:equatable/equatable.dart';
import 'package:smart_kishan/features/farmer/weather/data/weather_model.dart';

sealed class WeatherState extends Equatable {
  const WeatherState();
  @override
  List<Object?> get props => [];
}

class WeatherLoading extends WeatherState {
  const WeatherLoading();
}

class WeatherLoaded extends WeatherState {
  const WeatherLoaded({required this.weather, required this.willRainToday});
  final Weather weather;
  final bool willRainToday;
  @override
  List<Object?> get props => [weather, willRainToday];
}

class WeatherFailure extends WeatherState {
  const WeatherFailure();
}
