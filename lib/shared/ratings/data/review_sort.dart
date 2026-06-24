import 'review.dart';

/// Ordering options offered on the reviews page.
enum ReviewSort { newest, oldest, highest, lowest }

/// Returns a new list sorted per [sort] (does not mutate the input).
List<Review> sortReviews(List<Review> reviews, ReviewSort sort) {
  final list = [...reviews];
  final epoch = DateTime.fromMillisecondsSinceEpoch(0);
  switch (sort) {
    case ReviewSort.newest:
      list.sort(
        (a, b) => (b.createdAt ?? epoch).compareTo(a.createdAt ?? epoch),
      );
    case ReviewSort.oldest:
      list.sort(
        (a, b) => (a.createdAt ?? epoch).compareTo(b.createdAt ?? epoch),
      );
    case ReviewSort.highest:
      list.sort((a, b) => b.rating.compareTo(a.rating));
    case ReviewSort.lowest:
      list.sort((a, b) => a.rating.compareTo(b.rating));
  }
  return list;
}
