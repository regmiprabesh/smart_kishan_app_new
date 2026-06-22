import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_kishan/core/network/api_client.dart';

import '../data/subsidy_repository.dart';
import 'request_cancel_state.dart';

class RequestCancelCubit extends Cubit<RequestCancelState> {
  RequestCancelCubit(this._repo) : super(const RequestCancelIdle());

  final SubsidyRepository _repo;

  Future<void> cancel(int id) async {
    emit(const RequestCancelling());
    try {
      await _repo.cancelSubsidyRequest(id);
      if (isClosed) return;
      emit(const RequestCancelled());
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(RequestCancelFailure(e.message));
    } catch (_) {
      if (isClosed) return;
      emit(const RequestCancelFailure(''));
    }
  }
}
