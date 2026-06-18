import 'package:equatable/equatable.dart';

enum EditProfileError { network, validation, generic }

sealed class EditProfileState extends Equatable {
  const EditProfileState();
  @override
  List<Object?> get props => [];
}

class EditProfileInitial extends EditProfileState {
  const EditProfileInitial();
}

class EditProfileSaving extends EditProfileState {
  const EditProfileSaving();
}

class EditProfileSaved extends EditProfileState {
  const EditProfileSaved();
}

class EditProfileFailure extends EditProfileState {
  const EditProfileFailure(this.error);
  final EditProfileError error;
  @override
  List<Object?> get props => [error];
}
