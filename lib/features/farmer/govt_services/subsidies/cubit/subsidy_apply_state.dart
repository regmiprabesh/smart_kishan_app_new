import 'package:equatable/equatable.dart';

sealed class SubsidyApplyState extends Equatable {
  const SubsidyApplyState();
  @override
  List<Object?> get props => [];
}

class SubsidyApplyIdle extends SubsidyApplyState {
  const SubsidyApplyIdle();
}

class SubsidyApplySubmitting extends SubsidyApplyState {
  const SubsidyApplySubmitting({this.progress = 0});

  /// Upload fraction 0.0–1.0. Reaches 1.0 when bytes finish uploading; the
  /// server is then still processing (show an indeterminate 'finalizing').
  final double progress;

  @override
  List<Object?> get props => [progress];
}

class SubsidyApplySuccess extends SubsidyApplyState {
  const SubsidyApplySuccess();
}

class SubsidyApplyFailure extends SubsidyApplyState {
  const SubsidyApplyFailure(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
