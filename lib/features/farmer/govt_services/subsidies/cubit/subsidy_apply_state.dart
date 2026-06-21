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
  const SubsidyApplySubmitting();
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
