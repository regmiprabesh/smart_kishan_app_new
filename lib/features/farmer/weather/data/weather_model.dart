/// Current weather snapshot (OpenWeatherMap `/weather`).
class Weather {
  const Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.humidity,
  });

  final String cityName;
  final double temperature;
  final String mainCondition;
  final double humidity;

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'] as String? ?? '',
      temperature: (json['main']['temp'] as num).toDouble(),
      mainCondition: json['weather'][0]['main'] as String? ?? '',
      humidity: (json['main']['humidity'] as num).toDouble(),
    );
  }

  String get conditionAsset {
    switch (mainCondition.toLowerCase()) {
      case 'thunderstorm':
        return 'assets/animations/weather/cloud_thunder.json';
      case 'drizzle':
        return 'assets/animations/weather/rain_sun.json';
      case 'rain':
        return 'assets/animations/weather/rain_thunder.json';
      case 'snow':
        return 'assets/animations/weather/sun_snow.json';
      case 'clouds':
        return 'assets/animations/weather/cloud.json';
      case 'clear':
        return 'assets/animations/weather/sunny.json';
      default:
        return 'assets/animations/weather/sunny.json';
    }
  }
}
