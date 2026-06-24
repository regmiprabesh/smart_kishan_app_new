import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/ratings_repository.dart';
import '../data/review.dart';
import '../data/review_sort.dart';
import 'ratings_state.dart';

/// Feature-agnostic ratings controller. The headline average/total are seeded
/// from the entity snapshot the caller already has, then replaced with the
/// authoritative aggregate the server returns on every write; the reviews list
/// + the user's own review are (re)fetched from the [RatingsRepository] so
/// their content is authoritative too.
class RatingsCubit extends Cubit<RatingsState> {
  RatingsCubit(
    this._repo, {
    double seedAverage = 0,
    int seedTotal = 0,
    List<Review>? seedReviews,
    Review? seedMyReview,
  }) : super(
         RatingsState(
           average: seedAverage,
           total: seedTotal,
           loading: seedReviews == null,
           myReview: seedMyReview,
           reviews: seedReviews == null
               ? const []
               : sortReviews(seedReviews, ReviewSort.newest),
         ),
       );

  final RatingsRepository _repo;

  Future<void> load() async {
    emit(state.copyWith(loading: true));
    try {
      final reviews = await _repo.fetchReviews();
      final mine = await _repo.fetchMyReview();
      if (isClosed) return;
      emit(
        state.copyWith(
          loading: false,
          loaded: true,
          reviews: sortReviews(reviews, state.sort),
          myReview: mine,
          clearMyReview: mine == null,
        ),
      );
    } catch (e) {
      debugPrint('Load ratings failed: $e');
      if (isClosed) return;
      emit(state.copyWith(loading: false));
    }
  }

  void setSort(ReviewSort sort) {
    emit(state.copyWith(sort: sort, reviews: sortReviews(state.reviews, sort)));
  }

  Future<RatingMutationResult> submit({
    required int rating,
    String? text,
    List<String> tags = const [],
  }) async {
    if (state.submitting) return RatingMutationResult.failed;
    final wasRated = state.myReview != null;

    emit(state.copyWith(submitting: true));
    try {
      // The write returns the authoritative aggregate; the list + the user's
      // own review are refetched for content. No local average math — the
      // server is the source of truth, so the headline can't drift.
      final aggregate = await _repo.submitReview(
        rating: rating,
        text: text,
        tags: tags,
      );
      final reviews = await _repo.fetchReviews();
      final mine = await _repo.fetchMyReview();
      if (isClosed) return RatingMutationResult.failed;

      emit(
        state.copyWith(
          submitting: false,
          reviews: sortReviews(reviews, state.sort),
          myReview: mine,
          average: aggregate.average,
          total: aggregate.total,
        ),
      );
      return wasRated
          ? RatingMutationResult.updated
          : RatingMutationResult.submitted;
    } catch (e) {
      debugPrint('Submit rating failed: $e');
      if (isClosed) return RatingMutationResult.failed;
      emit(state.copyWith(submitting: false));
      return RatingMutationResult.failed;
    }
  }

  Future<RatingMutationResult> delete() async {
    if (state.myReview == null) return RatingMutationResult.failed;

    emit(state.copyWith(submitting: true));
    try {
      final aggregate = await _repo.deleteMyReview();
      final reviews = await _repo.fetchReviews();
      if (isClosed) return RatingMutationResult.failed;

      emit(
        state.copyWith(
          submitting: false,
          reviews: sortReviews(reviews, state.sort),
          clearMyReview: true,
          average: aggregate.average,
          total: aggregate.total,
        ),
      );
      return RatingMutationResult.deleted;
    } catch (e) {
      debugPrint('Delete rating failed: $e');
      if (isClosed) return RatingMutationResult.failed;
      emit(state.copyWith(submitting: false));
      return RatingMutationResult.failed;
    }
  }
}
