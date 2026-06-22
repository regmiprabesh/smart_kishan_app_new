import 'package:equatable/equatable.dart';

import '../data/subsidy.dart';

sealed class MyApplicationsState extends Equatable {
  const MyApplicationsState();
  @override
  List<Object?> get props => [];
}

class MyApplicationsLoading extends MyApplicationsState {
  const MyApplicationsLoading();
}

class MyApplicationsLoaded extends MyApplicationsState {
  const MyApplicationsLoaded(this.applications);

  /// Subsidies the farmer has applied to — each carries its [Subsidy.application]
  /// (status, dates, submitted form/documents).
  final List<Subsidy> applications;

  @override
  List<Object?> get props => [applications];
}

class MyApplicationsFailure extends MyApplicationsState {
  const MyApplicationsFailure();
}
