import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract final class Env {
  static String get apiBaseUrl => _require('API_BASE_URL');
  static String get owmApiKey => _require('OWM_API_KEY');

  static String _require(String key) {
    final value = dotenv.maybeGet(key);
    if (value == null || value.isEmpty) {
      throw StateError(
        'Missing "$key" in .env — copy .env.example to .env and fill it in.',
      );
    }
    return value;
  }

  static void validate() {
    apiBaseUrl;
    owmApiKey;
  }
}
