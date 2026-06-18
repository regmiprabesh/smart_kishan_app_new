import 'package:equatable/equatable.dart';

enum OtpStatus {
  idle,
  verifying,
  verified, // → carry verificationToken forward
  invalid, // 422 wrong code
  expired, // 410 code expired → request a new one
  noCode, // 404 no code on record → request a new one
  tooManyAttempts, // 429 on verify → request a new one
  resent,
  resendFailed,
  throttled, // 429 on resend (cooldown)
  network,
}

class OtpState extends Equatable {
  const OtpState({
    this.status = OtpStatus.idle,
    this.secondsLeft = 0,
    this.verificationToken = '',
    this.retryAfterSeconds,
    this.tick = 0,
  });

  final OtpStatus status;

  final int secondsLeft;
  final String verificationToken;
  final int? retryAfterSeconds;

  final int tick;

  bool get canResend => secondsLeft == 0 && status != OtpStatus.verifying;

  OtpState copyWith({
    OtpStatus? status,
    int? secondsLeft,
    String? verificationToken,
    int? retryAfterSeconds,
    int? tick,
  }) {
    return OtpState(
      status: status ?? this.status,
      secondsLeft: secondsLeft ?? this.secondsLeft,
      verificationToken: verificationToken ?? this.verificationToken,
      retryAfterSeconds: retryAfterSeconds ?? this.retryAfterSeconds,
      tick: tick ?? this.tick,
    );
  }

  @override
  List<Object?> get props => [
    status,
    secondsLeft,
    verificationToken,
    retryAfterSeconds,
    tick,
  ];
}
