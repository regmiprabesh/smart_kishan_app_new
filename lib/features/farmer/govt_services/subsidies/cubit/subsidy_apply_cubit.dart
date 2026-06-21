import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_kishan/core/network/api_client.dart';

import '../data/subsidy_repository.dart';
import 'subsidy_apply_state.dart';

class SubsidyApplyCubit extends Cubit<SubsidyApplyState> {
  SubsidyApplyCubit(this._repo) : super(const SubsidyApplyIdle());

  final SubsidyRepository _repo;

  Future<void> submit({
    required int subsidyId,
    required String notes,
    required Map<String, String> formData,
    required List<ApplyDocument> documents,
  }) async {
    emit(const SubsidyApplySubmitting());
    try {
      await _repo.apply(
        subsidyId: subsidyId,
        notes: notes,
        formData: formData,
        documents: documents,
      );
      emit(const SubsidyApplySuccess());
    } on ApiException catch (e) {
      emit(SubsidyApplyFailure(e.message));
    } catch (_) {
      emit(const SubsidyApplyFailure(''));
    }
  }
}
