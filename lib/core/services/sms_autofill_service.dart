import 'package:flutter/foundation.dart';
import 'package:smart_auth/smart_auth.dart';

/// Android OTP autofill via smart_auth 3.x (pinput 6 no longer bundles it).
///
/// smart_auth 3.x is a SINGLETON — `SmartAuth.instance`, no constructor —
/// and returns SmartAuthResult; read the code via `res.requireData.code`
/// (which itself can be null if the SMS arrived but no code was extracted).
///
/// Strategies:
///   • Retriever API ([listenForCode]) — auto-fill, NO user tap, but the
///     SMS MUST end with the app's 11-char signature hash (backend adds it;
///     get it from [getAppSignature]).
///   • User Consent API ([listenWithUserConsent]) — one-tap dialog, no hash.
///
/// Lifecycle: call a listen method when the OTP screen opens, [dispose]
/// when it closes. Android-only; safe no-op elsewhere (iOS autofill is
/// keyboard-driven).
class SmsAutofillService {
  final SmartAuth _smartAuth = SmartAuth.instance;

  /// SMS Retriever API — auto-fill, requires the signature hash in the SMS.
  Future<String?> listenForCode() async {
    try {
      final res = await _smartAuth.getSmsWithRetrieverApi();
      if (res.hasData) return res.requireData.code;
    } catch (e) {
      debugPrint('SMS retriever failed (manual entry still works): $e');
    }
    return null;
  }

  /// SMS User Consent API — one-tap permission dialog, no hash needed.
  Future<String?> listenWithUserConsent() async {
    try {
      final res = await _smartAuth.getSmsWithUserConsentApi();
      if (res.hasData) return res.requireData.code;
    } catch (e) {
      debugPrint('SMS user-consent failed (manual entry still works): $e');
    }
    return null;
  }

  /// One-time helper: the 11-char app signature hash for the backend team.
  /// (Differs between debug and release builds.)
  Future<String?> getAppSignature() async {
    final res = await _smartAuth.getAppSignature();
    debugPrint('SMS app signature hash: ${res.data}');
    return res.data;
  }

  Future<void> dispose() async {
    await _smartAuth.removeSmsRetrieverApiListener();
    await _smartAuth.removeUserConsentApiListener();
  }
}
