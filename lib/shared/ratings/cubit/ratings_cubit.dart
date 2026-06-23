import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../ratings_repository.dart';
import '../review.dart';
import '../review_sort.dart';
import 'ratings_state.dart';

/// Feature-agnostic ratings controller. The headline average/total are seeded
/// from the entity snapshot the caller already has, then kept current with
/// optimistic delta math on write; the reviews list + the user's own review are
/// (re)fetched from the [RatingsRepository] so their content is authoritative.
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
    final old = state.myReview;
    final wasRated = old != null;

    emit(state.copyWith(submitting: true));
    try {
      await _repo.submitReview(rating: rating, text: text, tags: tags);
      final reviews = await _repo.fetchReviews();
      final mine = await _repo.fetchMyReview();
      if (isClosed) return RatingMutationResult.failed;

      final total = wasRated ? state.total : state.total + 1;
      final average = wasRated
          ? (state.total == 0
                ? rating.toDouble()
                : ((state.average * state.total) - old.rating + rating) /
                      state.total)
          : ((state.average * state.total) + rating) / (state.total + 1);

      emit(
        state.copyWith(
          submitting: false,
          reviews: sortReviews(reviews, state.sort),
          myReview: mine,
          average: average,
          total: total,
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
    final old = state.myReview;
    if (old == null) return RatingMutationResult.failed;

    emit(state.copyWith(submitting: true));
    try {
      await _repo.deleteMyReview();
      final reviews = await _repo.fetchReviews();
      if (isClosed) return RatingMutationResult.failed;

      final total = (state.total - 1).clamp(0, 1 << 31);
      final average = total == 0
          ? 0.0
          : ((state.average * state.total) - old.rating) / total;

      emit(
        state.copyWith(
          submitting: false,
          reviews: sortReviews(reviews, state.sort),
          clearMyReview: true,
          average: average,
          total: total,
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
