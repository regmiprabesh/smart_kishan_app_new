import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_kishan/core/network/api_client.dart';
import 'package:smart_kishan/features/auth/data/auth_flow_args.dart';
import 'package:smart_kishan/features/auth/data/auth_repository.dart';
import 'package:smart_kishan/features/auth/cubit/register_details_state.dart';

class RegisterDetailsCubit extends Cubit<RegisterDetailsState> {
  RegisterDetailsCubit(this._authRepository, this.args)
    : super(const RegisterDetailsInitial());

  final AuthRepository _authRepository;
  final VerifiedFlowArgs args;

  Future<void> submit({
    required String fullName,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    if (state is RegisterDetailsLoading) return;
    emit(const RegisterDetailsLoading());

    try {
      final result = await _authRepository.register(
        fullName: fullName,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        phone: args.phone,
        verificationToken: args.verificationToken,
      );
      emit(RegisterDetailsSuccess(user: result.user, mode: result.mode));
    } on NoInternetException {
      emit(RegisterDetailsFailure(RegisterError.network));
    } on ValidationException catch (e) {
      final errors = e.errors;
      if (errors != null && errors.containsKey('verification_token')) {
        emit(RegisterDetailsFailure(RegisterError.verificationExpired));
      } else {
        emit(RegisterDetailsFailure(_classifyFields(errors)));
      }
    } on ApiException {
      emit(RegisterDetailsFailure(RegisterError.generic));
    }
  }

  RegisterError _classifyFields(Map<String, dynamic>? errors) {
    if (errors == null) return RegisterError.invalidData;
    if (errors.containsKey('email')) return RegisterError.emailTaken;
    if (errors.containsKey('phone')) return RegisterError.phoneTaken;
    return RegisterError.invalidData;
  }
}
