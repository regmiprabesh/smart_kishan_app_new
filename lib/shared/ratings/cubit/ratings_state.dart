import 'package:equatable/equatable.dart';

import '../review.dart';
import '../review_sort.dart';

/// Shared state for the ratings section + reviews/rate pages: the (sorted)
/// reviews, the current sort, the signed-in user's own review, the headline
/// aggregate, and in-flight flags.
class RatingsState extends Equatable {
  const RatingsState({
    this.loading = true,
    this.reviews = const [],
    this.sort = ReviewSort.newest,
    this.myReview,
    this.average = 0,
    this.total = 0,
    this.submitting = false,
  });

  final bool loading;
  final List<Review> reviews;
  final ReviewSort sort;
  final Review? myReview;
  final double average;
  final int total;
  final bool submitting;

  RatingsState copyWith({
    bool? loading,
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
    reviews,
    sort,
    myReview,
    average,
    total,
    submitting,
  ];
}
