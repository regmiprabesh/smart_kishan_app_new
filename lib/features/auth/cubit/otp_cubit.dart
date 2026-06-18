import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_kishan/core/network/api_client.dart';
import 'package:smart_kishan/features/auth/data/auth_flow_args.dart';
import 'package:smart_kishan/features/auth/data/auth_repository.dart';

import 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit(this._authRepository, this.args) : super(const OtpState()) {
    _startCountdown(); // an OTP was just sent to reach this screen
  }

  final AuthRepository _authRepository;
  final OtpFlowArgs args;

  Timer? _timer;
  int _tick = 0;

  static const int _resendCooldown = 60;

  Future<void> verify(String code) async {
    if (state.status == OtpStatus.verifying) return;
    emit(state.copyWith(status: OtpStatus.verifying));

    try {
      final token = await _authRepository.verifyOtp(
        phone: args.phone,
        otp: code,
        purpose: args.purpose,
      );
      emit(
        state.copyWith(
          status: OtpStatus.verified,
          verificationToken: token,
          tick: ++_tick,
        ),
      );
    } on NoInternetException {
      emit(state.copyWith(status: OtpStatus.network, tick: ++_tick));
    } on ApiException catch (e) {
      // Distinct verify failures from the standardized OTP controller.
      final status = switch (e.statusCode) {
        410 => OtpStatus.expired,
        404 => OtpStatus.noCode,
        429 => OtpStatus.tooManyAttempts,
        _ => OtpStatus.invalid, // 422 wrong code (+ any other)
      };
      emit(state.copyWith(status: status, tick: ++_tick));
    }
  }

  Future<void> resend() async {
    if (!state.canResend) return;
    _startCountdown();

    try {
      await _authRepository.sendOtp(phone: args.phone, purpose: args.purpose);
      emit(state.copyWith(status: OtpStatus.resent, tick: ++_tick));
    } on ThrottledException catch (e) {
      _timer?.cancel(); // re-enable the resend button
      emit(
        state.copyWith(
          status: OtpStatus.throttled,
          retryAfterSeconds: e.retryAfterSeconds,
          secondsLeft: 0,
          tick: ++_tick,
        ),
      );
    } on NoInternetException {
      _timer?.cancel();
      emit(
        state.copyWith(
          status: OtpStatus.network,
          secondsLeft: 0,
          tick: ++_tick,
        ),
      );
    } on ApiException {
      _timer?.cancel();
      emit(
        state.copyWith(
          status: OtpStatus.resendFailed,
          secondsLeft: 0,
          tick: ++_tick,
        ),
      );
    }
  }

  void _startCountdown() {
    _timer?.cancel();
    emit(state.copyWith(secondsLeft: _resendCooldown));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final next = state.secondsLeft - 1;
      if (next <= 0) {
        timer.cancel();
        emit(state.copyWith(secondsLeft: 0));
      } else {
        emit(state.copyWith(secondsLeft: next));
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
