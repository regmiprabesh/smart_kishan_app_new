import 'package:equatable/equatable.dart';

sealed class RequestCancelState extends Equatable {
  const RequestCancelState();
  @override
  List<Object?> get props => [];
}

class RequestCancelIdle extends RequestCancelState {
  const RequestCancelIdle();
}

class RequestCancelling extends RequestCancelState {
  const RequestCancelling();
}

class RequestCancelled extends RequestCancelState {
  const RequestCancelled();
}

class RequestCancelFailure extends RequestCancelState {
  const RequestCancelFailure(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
