/// Single source of truth for every local-storage key.
abstract final class StorageKeys {
  static const String token = 'jwt'; // secure storage
  static const String user = 'user';
  static const String languageCode = 'languageCode';
  static const String firstLaunch = 'firstLaunch';
  static const String appMode = 'appMode';
  static const String themeMode = 'themeMode';
}
