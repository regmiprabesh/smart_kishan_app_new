import 'package:equatable/equatable.dart';

/// Why the OTP request failed — the SCREEN maps these to l10n strings.
enum OtpSendError {
  alreadyRegistered, // 409, register flow
  notRegistered, // 404, reset flow
  throttled, // 429
  network,
  generic,
}

sealed class PhoneEntryState extends Equatable {
  const PhoneEntryState();
  @override
  List<Object?> get props => [];
}

class PhoneEntryInitial extends PhoneEntryState {
  const PhoneEntryInitial();
}

class PhoneEntryLoading extends PhoneEntryState {
  const PhoneEntryLoading();
}

/// `tick` makes consecutive identical outcomes distinct states so the
/// BlocListener fires every time (e.g. resubmitting the same phone).
class PhoneEntrySuccess extends PhoneEntryState {
  const PhoneEntrySuccess({required this.phone});
  final String phone;
  @override
  List<Object?> get props => [phone];
}

class PhoneEntryFailure extends PhoneEntryState {
  const PhoneEntryFailure(this.error, {this.retryAfterSeconds});
  final OtpSendError error;
  final int? retryAfterSeconds;
  @override
  List<Object?> get props => [error, retryAfterSeconds];
}
