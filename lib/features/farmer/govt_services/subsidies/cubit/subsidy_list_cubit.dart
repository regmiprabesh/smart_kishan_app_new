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

  /// Refetch without a loading flash: keeps the current list on screen and
  /// swaps it once new data arrives. Called when returning from detail so a
  /// rating/aggregate change there is reflected on the cards.
  Future<void> refresh() async {
    try {
      final subsidies = await _repo.fetchSubsidies();
      emit(SubsidyListLoaded(subsidies));
    } catch (e) {
      debugPrint('Subsidies refresh failed: $e');
      if (state is! SubsidyListLoaded) emit(const SubsidyListFailure());
      // else keep the existing list visible rather than flashing an error.
    }
  }

  /// Patch one subsidy's rating aggregate in place — no refetch. Called when a
  /// rating made on the detail screen reports the new server aggregate, so the
  /// card reflects it immediately.
  void updateAggregate(int id, double average, int total) {
    final current = state;
    if (current is! SubsidyListLoaded) return;
    emit(
      SubsidyListLoaded([
        for (final s in current.subsidies)
          s.id == id
              ? s.copyWith(averageRating: average, totalRatings: total)
              : s,
      ]),
    );
  }

  /// Mark one subsidy as applied in place — no network refetch. Called after a
  /// successful application so the card/badge reflect it immediately.
  void markApplied(int id) {
    final current = state;
    if (current is! SubsidyListLoaded) return;
    emit(
      SubsidyListLoaded([
        for (final s in current.subsidies)
          s.id == id ? s.copyWith(hasApplied: true) : s,
      ]),
    );
  }
}
