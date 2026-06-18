import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_kishan/core/enums/app_mode.dart';
import 'package:smart_kishan/features/auth/data/auth_repository.dart';
import 'package:smart_kishan/features/auth/cubit/session_state.dart';
import 'package:smart_kishan/shared/models/user.dart';

/// THE app-wide auth state. One instance, created in main(), provided at
/// the root. Everything reacts to it:
///   - go_router redirect  → which screens are reachable
///   - ApiClient 401       → [expire] (single session-expiry path)
///   - SignInCubit success → [signedIn]
///
/// Cubits never navigate — emitting a new state IS the navigation,
/// because the router re-runs its redirect on every session change.
class SessionCubit extends Cubit<SessionState> {
  SessionCubit(this._authRepository) : super(const SessionUnknown());

  final AuthRepository _authRepository;

  static const _minSplash = Duration(milliseconds: 1200);

  /// Called once at startup. Reads ONLY local storage — zero API calls,
  /// so launch is instant and works offline.
  Future<void> restore() async {
    final results = await Future.wait<dynamic>([
      _authRepository.restoreSession(),
      Future.delayed(_minSplash), // let the branding splash breathe
    ]);
    final session = results[0] as ({String mode, User user})?;

    if (session == null) {
      emit(const Unauthenticated());
    } else {
      emit(Authenticated(user: session.user, mode: session.mode));
    }
  }

  /// After successful login / registration (repository already persisted).
  /// Update the cached user in the global session (after a profile edit /
  /// image upload) without changing auth status or mode.
  void refreshUser(User user) {
    final current = state;
    if (current is Authenticated) {
      emit(Authenticated(user: user, mode: current.mode));
    }
  }

  void signedIn({required User user, String? mode}) {
    emit(Authenticated(user: user, mode: mode ?? AppMode.farmer));
  }

  /// Mode switch (farmer ⇄ buyer ⇄ seller). Local-first; the repository
  /// syncs to the server in the background.
  Future<void> switchMode(String mode) async {
    final current = state;
    if (current is! Authenticated) return;
    emit(Authenticated(user: current.user, mode: mode));
    await _authRepository.persistMode(mode);
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    emit(const Unauthenticated());
  }

  /// ApiClient calls this on any 401 — the single session-expiry path.
  Future<void> expire() async {
    if (state is! Authenticated) return;
    await _authRepository.signOut();
    emit(const Unauthenticated());
    // Optional: AppSnackbar.error with a localized "session expired"
    // message — add in Phase 2 once the l10n key exists.
  }
}
