import 'package:equatable/equatable.dart';
import 'package:smart_kishan/shared/models/user.dart';

enum RegisterError {
  network,
  emailTaken, // 422, email field
  phoneTaken, // 422, phone field
  invalidData, // 422, other/unmapped field
  verificationExpired, // 422 verification_token error — OTP expired/missing
  generic,
}

sealed class RegisterDetailsState extends Equatable {
  const RegisterDetailsState();
  @override
  List<Object?> get props => [];
}

class RegisterDetailsInitial extends RegisterDetailsState {
  const RegisterDetailsInitial();
}

class RegisterDetailsLoading extends RegisterDetailsState {
  const RegisterDetailsLoading();
}

class RegisterDetailsSuccess extends RegisterDetailsState {
  const RegisterDetailsSuccess({required this.user, required this.mode});
  final User user;
  final String mode;
  @override
  List<Object?> get props => [user, mode];
}

class RegisterDetailsFailure extends RegisterDetailsState {
  const RegisterDetailsFailure(this.reason);
  final RegisterError reason;
  @override
  List<Object?> get props => [reason];
}
