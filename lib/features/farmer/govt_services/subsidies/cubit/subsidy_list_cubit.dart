import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/subsidy_repository.dart';
import 'subsidy_list_state.dart';

class SubsidyListCubit extends Cubit<SubsidyListState> {
  SubsidyListCubit(this._repo) : super(const SubsidyListLoading());

  final SubsidyRepository _repo;

  /// Fetch the location-scoped available subsidies. Called by the screen only
  /// once the user's location is confirmed present.
  Future<void> load() async {
    emit(const SubsidyListLoading());
    try {
      final subsidies = await _repo.fetchSubsidies();
      emit(SubsidyListLoaded(subsidies));
    } catch (e) {
      debugPrint('Subsidies load failed: $e');
      emit(const SubsidyListFailure());
    }
  }
}
