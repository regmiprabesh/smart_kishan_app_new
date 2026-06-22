import 'package:equatable/equatable.dart';

sealed class RequestSubsidyState extends Equatable {
  const RequestSubsidyState();
  @override
  List<Object?> get props => [];
}

class RequestSubsidyIdle extends RequestSubsidyState {
  const RequestSubsidyIdle();
}

class RequestSubsidySubmitting extends RequestSubsidyState {
  const RequestSubsidySubmitting();
}

class RequestSubsidySuccess extends RequestSubsidyState {
  const RequestSubsidySuccess();
}

class RequestSubsidyFailure extends RequestSubsidyState {
  const RequestSubsidyFailure(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
