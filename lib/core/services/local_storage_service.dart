import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/storage_keys.dart';

/// The ONLY class that touches SharedPreferences / FlutterSecureStorage.
/// Plain class (no framework base) — registered once in get_it:
///   sl.registerSingleton(await LocalStorageService.init());
class LocalStorageService {
  LocalStorageService._(this._prefs);

  final SharedPreferences _prefs;
  final FlutterSecureStorage _secure = const FlutterSecureStorage();

  static Future<LocalStorageService> init() async {
    return LocalStorageService._(await SharedPreferences.getInstance());
  }

  // ── Auth token (secure) ─────────────────────────────────────
  Future<void> saveToken(String token) =>
      _secure.write(key: StorageKeys.token, value: token);

  Future<String?> getToken() => _secure.read(key: StorageKeys.token);

  // ── Cached user ─────────────────────────────────────────────
  Future<void> saveUser(Map<String, dynamic> userJson) =>
      _prefs.setString(StorageKeys.user, jsonEncode(userJson));

  Map<String, dynamic>? getUser() {
    final raw = _prefs.getString(StorageKeys.user);
    return raw == null ? null : jsonDecode(raw) as Map<String, dynamic>;
  }

  // ── Language (sync read — available before first frame) ────
  Future<void> saveLanguageCode(String code) =>
      _prefs.setString(StorageKeys.languageCode, code);

  String? getLanguageCode() => _prefs.getString(StorageKeys.languageCode);

  // ── Onboarding ──────────────────────────────────────────────
  Future<void> setOnboardingDone() =>
      _prefs.setBool(StorageKeys.firstLaunch, false);

  bool get isFirstLaunch => _prefs.getBool(StorageKeys.firstLaunch) ?? true;

  // ── Theme (sync read — available before first frame) ───────
  Future<void> saveThemeMode(String mode) =>
      _prefs.setString(StorageKeys.themeMode, mode);

  String? getThemeMode() => _prefs.getString(StorageKeys.themeMode);

  // ── App mode ────────────────────────────────────────────────
  Future<void> saveAppMode(String mode) =>
      _prefs.setString(StorageKeys.appMode, mode);

  String? getAppMode() => _prefs.getString(StorageKeys.appMode);

  // ── Session teardown ────────────────────────────────────────
  /// Language + onboarding flags deliberately SURVIVE logout
  /// (language persistence requirement).
  Future<void> clearSession() async {
    await _prefs.remove(StorageKeys.user);
    await _prefs.remove(StorageKeys.appMode);
    await _secure.delete(key: StorageKeys.token);
  }
}
