import 'package:equatable/equatable.dart';

sealed class ResetPasswordState extends Equatable {
  const ResetPasswordState();
  @override
  List<Object?> get props => [];
}

class ResetPasswordInitial extends ResetPasswordState {
  const ResetPasswordInitial();
}

class ResetPasswordLoading extends ResetPasswordState {
  const ResetPasswordLoading();
}

class ResetPasswordSuccess extends ResetPasswordState {
  const ResetPasswordSuccess();
}

class ResetPasswordFailure extends ResetPasswordState {
  const ResetPasswordFailure(
      {this.serverMessage, this.isNetworkError = false, required this.tick});
  final String? serverMessage;
  final bool isNetworkError;
  final int tick;
  @override
  List<Object?> get props => [serverMessage, isNetworkError, tick];
}
