import 'package:equatable/equatable.dart';

import '../data/review.dart';
import '../data/review_sort.dart';

/// Shared state for the ratings section + reviews/rate pages: the (sorted)
/// reviews, the current sort, the signed-in user's own review, the headline
/// aggregate, and in-flight flags.
class RatingsState extends Equatable {
  const RatingsState({
    this.loading = true,
    this.loaded = false,
    this.reviews = const [],
    this.sort = ReviewSort.newest,
    this.myReview,
    this.average = 0,
    this.total = 0,
    this.submitting = false,
  });

  final bool loading;

  /// True once the full list has been fetched from the repository (vs. merely
  /// seeded with a preview). Lets the reviews page skip a redundant fetch when
  /// the detail screen already loaded.
  final bool loaded;
  final List<Review> reviews;
  final ReviewSort sort;
  final Review? myReview;
  final double average;
  final int total;
  final bool submitting;

  RatingsState copyWith({
    bool? loading,
    bool? loaded,
    List<Review>? reviews,
    ReviewSort? sort,
    Review? myReview,
    bool clearMyReview = false,
    double? average,
    int? total,
    bool? submitting,
  }) {
    return RatingsState(
      loading: loading ?? this.loading,
      loaded: loaded ?? this.loaded,
      reviews: reviews ?? this.reviews,
      sort: sort ?? this.sort,
      myReview: clearMyReview ? null : (myReview ?? this.myReview),
      average: average ?? this.average,
      total: total ?? this.total,
      submitting: submitting ?? this.submitting,
    );
  }

  @override
  List<Object?> get props => [
    loading,
    loaded,
    reviews,
    sort,
    myReview,
    average,
    total,
    submitting,
  ];
}
