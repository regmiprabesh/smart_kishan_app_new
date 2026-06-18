import 'package:equatable/equatable.dart';

enum SignInError { invalidCredentials, network, generic }

sealed class SignInState extends Equatable {
  const SignInState();
  @override
  List<Object?> get props => [];
}

class SignInInitial extends SignInState {
  const SignInInitial();
}

class SignInLoading extends SignInState {
  const SignInLoading();
}

/// Failure types map to localized messages IN THE SCREEN (where l10n
/// lives). serverMessage is shown as-is when the backend provides one.
class SignInFailure extends SignInState {
  const SignInFailure({required this.reason});
  final SignInError reason;
  @override
  List<Object?> get props => [reason];
}

// No "success" state: on success SessionCubit emits Authenticated and the
// router redirects away — this screen is gone before it could react.
