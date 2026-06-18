import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_client.dart';
import '../data/auth_flow_args.dart';
import '../data/auth_repository.dart';
import 'reset_password_state.dart';

/// Password reset step 3: new password. Phone + verification token
/// arrive via [args] from the OTP step.
class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit(this._authRepository, this.args)
      : super(const ResetPasswordInitial());

  final AuthRepository _authRepository;
  final VerifiedFlowArgs args;

  int _tick = 0;

  Future<void> submit({
    required String password,
    required String passwordConfirmation,
  }) async {
    if (state is ResetPasswordLoading) return;
    emit(const ResetPasswordLoading());

    try {
      await _authRepository.resetPassword(
        phone: args.phone,
        verificationToken: args.verificationToken,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      emit(const ResetPasswordSuccess());
    } on NoInternetException {
      emit(ResetPasswordFailure(isNetworkError: true, tick: ++_tick));
    } on ApiException catch (e) {
      emit(ResetPasswordFailure(serverMessage: e.message, tick: ++_tick));
    }
  }
}
