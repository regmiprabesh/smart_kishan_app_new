import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_kishan/core/network/api_client.dart';
import 'package:smart_kishan/features/auth/session/cubit/session_cubit.dart';
import 'package:smart_kishan/features/profile/cubit/edit_profile_state.dart';
import 'package:smart_kishan/features/profile/data/profile_repository.dart';

/// Edit-profile form logic. On success it refreshes the global session so
/// every screen (drawer header, profile tab) reflects the new details.
class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit(this._repository, this._sessionCubit)
    : super(const EditProfileInitial());

  final ProfileRepository _repository;
  final SessionCubit _sessionCubit;

  Future<void> save({
    required String name,
    required String email,
    required String phone,
  }) async {
    if (state is EditProfileSaving) return;
    emit(const EditProfileSaving());
    try {
      final user = await _repository.updateProfile(
        name: name,
        email: email,
        phone: phone,
      );
      _sessionCubit.refreshUser(user); // keep global state in sync
      emit(const EditProfileSaved());
    } on NoInternetException {
      emit(const EditProfileFailure(EditProfileError.network));
    } on ValidationException {
      emit(const EditProfileFailure(EditProfileError.validation));
    } on ApiException {
      emit(const EditProfileFailure(EditProfileError.generic));
    }
  }
}
