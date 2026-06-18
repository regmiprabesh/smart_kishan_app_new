import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_kishan/core/network/api_client.dart';
import 'package:smart_kishan/features/auth/data/auth_repository.dart';
import 'package:smart_kishan/features/auth/cubit/session_cubit.dart';

import 'sign_in_state.dart';

/// Login form logic. Created per-visit by the route (see app_router.dart),
/// disposed automatically when the screen closes.
class SignInCubit extends Cubit<SignInState> {
  SignInCubit(this._authRepository, this._sessionCubit)
    : super(const SignInInitial());

  final AuthRepository _authRepository;
  final SessionCubit _sessionCubit;

  Future<void> submit({required String phone, required String password}) async {
    if (state is SignInLoading) return; // double-tap guard
    emit(const SignInLoading());

    try {
      final result = await _authRepository.login(
        phone: phone,
        password: password,
      );
      // This emit IS the navigation: router redirects to ?from= or the
      // mode dashboard.
      _sessionCubit.signedIn(user: result.user, mode: result.mode);
    } on UnauthorizedException {
      emit(const SignInFailure(reason: SignInError.invalidCredentials));
    } on NoInternetException {
      emit(const SignInFailure(reason: SignInError.network));
    } on ApiException {
      emit(const SignInFailure(reason: SignInError.generic));
    }
  }
}
