import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/subsidy_repository.dart';
import 'my_requests_state.dart';

class MyRequestsCubit extends Cubit<MyRequestsState> {
  MyRequestsCubit(this._repo) : super(const MyRequestsLoading());

  final SubsidyRepository _repo;

  Future<void> load() async {
    emit(const MyRequestsLoading());
    try {
      final requests = await _repo.fetchMyRequests();
      emit(MyRequestsLoaded(requests));
    } catch (e) {
      debugPrint('My requests load failed: $e');
      emit(const MyRequestsFailure());
    }
  }

  /// Drop a cancelled request in place — no refetch.
  void removeRequest(int id) {
    final current = state;
    if (current is! MyRequestsLoaded) return;
    emit(MyRequestsLoaded(
      current.requests.where((r) => r.id != id).toList(),
    ));
  }
}
