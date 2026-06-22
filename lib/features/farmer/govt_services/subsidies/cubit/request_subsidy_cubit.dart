import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_kishan/core/network/api_client.dart';

import '../data/subsidy_repository.dart';
import 'request_subsidy_state.dart';

class RequestSubsidyCubit extends Cubit<RequestSubsidyState> {
  RequestSubsidyCubit(this._repo) : super(const RequestSubsidyIdle());

  final SubsidyRepository _repo;

  Future<void> submit({
    required String title,
    required String description,
    required String subsidyType,
    required String justification,
    required String requestedToLevel,
    String? targetCropOrSector,
  }) async {
    emit(const RequestSubsidySubmitting());
    try {
      await _repo.createSubsidyRequest(
        title: title,
        description: description,
        subsidyType: subsidyType,
        justification: justification,
        requestedToLevel: requestedToLevel,
        targetCropOrSector: targetCropOrSector,
      );
      if (isClosed) return;
      emit(const RequestSubsidySuccess());
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(RequestSubsidyFailure(e.message));
    } catch (_) {
      if (isClosed) return;
      emit(const RequestSubsidyFailure(''));
    }
  }
}
