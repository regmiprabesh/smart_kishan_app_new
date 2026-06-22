import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/subsidy_repository.dart';
import 'my_applications_state.dart';

class MyApplicationsCubit extends Cubit<MyApplicationsState> {
  MyApplicationsCubit(this._repo) : super(const MyApplicationsLoading());

  final SubsidyRepository _repo;

  Future<void> load() async {
    emit(const MyApplicationsLoading());
    try {
      final apps = await _repo.fetchMyApplications();
      emit(MyApplicationsLoaded(apps));
    } catch (e) {
      debugPrint('My applications load failed: $e');
      emit(const MyApplicationsFailure());
    }
  }

  /// Drop a withdrawn application in place — no refetch. Called after a
  /// successful withdrawal in the detail screen.
  void removeApplication(int subsidyId) {
    final current = state;
    if (current is! MyApplicationsLoaded) return;
    emit(MyApplicationsLoaded(
      current.applications.where((s) => s.id != subsidyId).toList(),
    ));
  }
}
