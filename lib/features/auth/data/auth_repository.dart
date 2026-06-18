import 'package:flutter/foundation.dart';
import 'package:smart_kishan/core/constants/api_endpoints.dart';
import 'package:smart_kishan/core/enums/app_mode.dart';
import 'package:smart_kishan/core/network/api_client.dart';
import 'package:smart_kishan/core/services/local_storage_service.dart';
import 'package:smart_kishan/core/services/notification_service.dart';
import 'package:smart_kishan/features/auth/data/otp_purpose.dart';
import 'package:smart_kishan/shared/models/user.dart';

/// All auth data operations: API + persistence. Cubits never touch
/// ApiClient or storage directly — only this repository.
class AuthRepository {
  AuthRepository({
    required ApiClient api,
    required LocalStorageService storage,
    required NotificationService notifications,
  }) : _api = api,
       _storage = storage,
       _notifications = notifications;

  final ApiClient _api;
  final LocalStorageService _storage;
  final NotificationService _notifications;

  // ── Sign in ─────────────────────────────────────────────────
  Future<({User user, String mode})> login({
    required String phone,
    required String password,
  }) async {
    final response = await _api.post(
      ApiEndpoints.login,
      auth: false,
      body: {
        'phone': _normalizePhone(phone),
        'password': password,
        if (_notifications.token != null) 'fcm_token': _notifications.token,
      },
    );
    return _persistSession(response.data as Map<String, dynamic>);
  }

  // ── OTP (shared by registration + password reset) ───────────
  /// Throws: ServerException(409) phone already registered (register),
  /// ServerException(404) phone not registered (reset),
  /// ThrottledException(429), NoInternetException.
  Future<void> sendOtp({
    required String phone,
    required OtpPurpose purpose,
  }) async {
    await _api.post(
      ApiEndpoints.sendOtp,
      auth: false,
      body: {'phone': _normalizePhone(phone), 'purpose': _purposeKey(purpose)},
    );
  }

  /// Returns the single-use verification token on success.
  /// Throws ServerException on a wrong code.
  Future<String> verifyOtp({
    required String phone,
    required String otp,
    required OtpPurpose purpose,
  }) async {
    final response = await _api.post(
      ApiEndpoints.verifyOtp,
      auth: false,
      body: {
        'phone': _normalizePhone(phone),
        'otp': otp,
        'purpose': _purposeKey(purpose),
      },
    );
    // verify-otp lives in the (not-yet-standardized) OTP controller, which
    // returns the token at top level. Prefer the standard `data` envelope
    // if/when that controller is migrated, else fall back to top level.
    final data = response.data;
    if (data is Map && data['verification_token'] != null) {
      return data['verification_token'] as String;
    }
    return response.body['verification_token'] as String? ?? '';
  }

  // ── Registration (after OTP verification) ───────────────────
  /// TODO: verify the exact field names ('name' vs 'full_name') and the
  /// response envelope against your backend's register endpoint.
  Future<({User user, String mode})> register({
    required String fullName,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phone,
    required String verificationToken,
  }) async {
    final response = await _api.post(
      ApiEndpoints.register,
      auth: false,
      body: {
        'name': fullName,
        if (email.isNotEmpty) 'email': email,
        'phone': _normalizePhone(phone),
        'password': password,
        'password_confirmation': passwordConfirmation,
        'verification_token': verificationToken,
        if (_notifications.token != null) 'fcm_token': _notifications.token,
      },
    );
    return _persistSession(response.data as Map<String, dynamic>);
  }

  // ── Password reset (after OTP verification) ─────────────────
  Future<void> resetPassword({
    required String phone,
    required String verificationToken,
    required String password,
    required String passwordConfirmation,
  }) async {
    await _api.post(
      ApiEndpoints.resetPassword,
      auth: false,
      body: {
        'phone': _normalizePhone(phone),
        'verification_token': verificationToken,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );
  }

  // ── Session ─────────────────────────────────────────────────
  Future<({String mode, User user})?> restoreSession() async {
    final token = await _storage.getToken();
    final userJson = _storage.getUser();
    if (token == null || userJson == null) return null;
    return (
      mode: _storage.getAppMode() ?? AppMode.farmer,
      user: User.fromJson(userJson),
    );
  }

  Future<void> persistMode(String mode) async {
    await _storage.saveAppMode(mode);
    try {
      await _api.post(ApiEndpoints.switchMode, body: {'mode': mode});
    } on ApiException catch (e) {
      debugPrint('Mode sync failed (will resync next login): $e');
    }
  }

  Future<void> signOut() => _storage.clearSession();

  // ── Internals ───────────────────────────────────────────────
  /// Shared by login + register: persist token/user/mode, return both.
  /// Standard envelope — token + user live under `data`:
  ///   { "success": true, "data": { "token": "...", "user": {...} } }
  /// ApiResponse.data already unwraps `body['data']`. Shared by
  /// login() and register().
  Future<({User user, String mode})> _persistSession(
    Map<String, dynamic> data,
  ) async {
    final token = data['token'] as String;
    final userJson = data['user'] as Map<String, dynamic>;
    final user = User.fromJson(userJson);
    final mode = (userJson['mode'] as String?)?.isNotEmpty == true
        ? userJson['mode'] as String
        : AppMode.farmer;

    await _storage.saveToken(token);
    await _storage.saveUser(userJson);
    await _storage.saveAppMode(mode);
    return (user: user, mode: mode);
  }

  /// Backend expects E.164-ish '+977XXXXXXXXXX'. Callers pass the raw
  /// 10-digit number; we prefix here so EVERY endpoint (login, register,
  /// send-otp, verify-otp, reset) sends the SAME format — the old app was
  /// inconsistent (some +977, some raw), a latent bug. One choke point.
  String _normalizePhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    return digits.startsWith('977') ? '+$digits' : '+977$digits';
  }

  String _purposeKey(OtpPurpose purpose) => switch (purpose) {
    OtpPurpose.registration => 'register',
    OtpPurpose.passwordReset => 'reset',
  };
}
