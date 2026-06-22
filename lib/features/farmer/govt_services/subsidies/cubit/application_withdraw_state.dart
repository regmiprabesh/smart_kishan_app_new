import 'package:equatable/equatable.dart';

sealed class ApplicationWithdrawState extends Equatable {
  const ApplicationWithdrawState();
  @override
  List<Object?> get props => [];
}

class ApplicationWithdrawIdle extends ApplicationWithdrawState {
  const ApplicationWithdrawIdle();
}

class ApplicationWithdrawing extends ApplicationWithdrawState {
  const ApplicationWithdrawing();
}

class ApplicationWithdrawn extends ApplicationWithdrawState {
  const ApplicationWithdrawn();
}

class ApplicationWithdrawFailure extends ApplicationWithdrawState {
  const ApplicationWithdrawFailure(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
