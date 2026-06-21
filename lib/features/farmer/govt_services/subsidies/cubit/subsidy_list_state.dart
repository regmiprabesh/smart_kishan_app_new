import 'package:equatable/equatable.dart';

import '../data/subsidy.dart';

sealed class SubsidyListState extends Equatable {
  const SubsidyListState();
  @override
  List<Object?> get props => [];
}

class SubsidyListLoading extends SubsidyListState {
  const SubsidyListLoading();
}

class SubsidyListLoaded extends SubsidyListState {
  const SubsidyListLoaded(this.subsidies);
  final List<Subsidy> subsidies;
  @override
  List<Object?> get props => [subsidies];
}

class SubsidyListFailure extends SubsidyListState {
  const SubsidyListFailure();
}
