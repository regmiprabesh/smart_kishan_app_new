import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_client.dart';
import '../../data/auth_repository.dart';
import '../../data/otp_purpose.dart';
import 'phone_entry_state.dart';

class PhoneEntryCubit extends Cubit<PhoneEntryState> {
  PhoneEntryCubit(this._authRepository, {required this.purpose})
    : super(const PhoneEntryInitial());

  final AuthRepository _authRepository;
  final OtpPurpose purpose;

  Future<void> submit(String phone) async {
    if (state is PhoneEntryLoading) return;
    emit(const PhoneEntryLoading());

    try {
      await _authRepository.sendOtp(phone: phone, purpose: purpose);
      emit(PhoneEntrySuccess(phone: phone));
    } on ThrottledException catch (e) {
      emit(
        PhoneEntryFailure(
          OtpSendError.throttled,
          retryAfterSeconds: e.retryAfterSeconds,
        ),
      );
    } on NoInternetException {
      emit(PhoneEntryFailure(OtpSendError.network));
    } on ApiException catch (e) {
      final error = switch (e.statusCode) {
        409 => OtpSendError.alreadyRegistered,
        404 => OtpSendError.notRegistered,
        502 => OtpSendError.generic, // SMS gateway down → "couldn't send"
        _ => OtpSendError.generic,
      };
      emit(PhoneEntryFailure(error));
    }
  }
}
