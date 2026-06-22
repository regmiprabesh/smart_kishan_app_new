import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_kishan/core/network/api_client.dart';

import '../data/subsidy_repository.dart';
import 'application_withdraw_state.dart';

class ApplicationWithdrawCubit extends Cubit<ApplicationWithdrawState> {
  ApplicationWithdrawCubit(this._repo) : super(const ApplicationWithdrawIdle());

  final SubsidyRepository _repo;

  Future<void> withdraw(int subsidyId) async {
    emit(const ApplicationWithdrawing());
    try {
      await _repo.withdrawApplication(subsidyId);
      if (isClosed) return;
      emit(const ApplicationWithdrawn());
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(ApplicationWithdrawFailure(e.message));
    } catch (_) {
      if (isClosed) return;
      emit(const ApplicationWithdrawFailure(''));
    }
  }
}
