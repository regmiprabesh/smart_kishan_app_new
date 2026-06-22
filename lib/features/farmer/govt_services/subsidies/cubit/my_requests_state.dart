import 'package:equatable/equatable.dart';

import '../data/subsidy_request.dart';

sealed class MyRequestsState extends Equatable {
  const MyRequestsState();
  @override
  List<Object?> get props => [];
}

class MyRequestsLoading extends MyRequestsState {
  const MyRequestsLoading();
}

class MyRequestsLoaded extends MyRequestsState {
  const MyRequestsLoaded(this.requests);
  final List<SubsidyRequest> requests;
  @override
  List<Object?> get props => [requests];
}

class MyRequestsFailure extends MyRequestsState {
  const MyRequestsFailure();
}
