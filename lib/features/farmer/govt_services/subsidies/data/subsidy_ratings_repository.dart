import 'package:smart_kishan/shared/ratings/data/rating_aggregate.dart';
import 'package:smart_kishan/shared/ratings/data/ratings_repository.dart';
import 'package:smart_kishan/shared/ratings/data/review.dart';

import 'subsidy_rating.dart';
import 'subsidy_repository.dart';

/// Adapts the subsidies API to the shared [RatingsRepository] so subsidies can
/// reuse the core ratings section / reviews page / rate page.
class SubsidyRatingsRepository implements RatingsRepository {
  SubsidyRatingsRepository(this._repo, this.subsidyId);

  final SubsidyRepository _repo;
  final int subsidyId;

  @override
  Future<List<Review>> fetchReviews() async {
    final list = await _repo.fetchRatings(subsidyId);
    return list.map(_toReview).toList();
  }

  @override
  Future<Review?> fetchMyReview() async {
    final r = await _repo.fetchMyRating(subsidyId);
    return r == null ? null : _toReview(r);
  }

  @override
  Future<RatingAggregate> submitReview({
    required int rating,
    String? text,
    required List<String> tags,
  }) => _repo.rateSubsidy(
    subsidyId: subsidyId,
    rating: rating,
    review: text,
    tags: tags,
  );

  @override
  Future<RatingAggregate> deleteMyReview() => _repo.deleteRating(subsidyId);

  Review _toReview(SubsidyRating r) => Review(
    id: r.id,
    userName: r.userName,
    rating: r.rating,
    text: r.review,
    createdAt: DateTime.tryParse(r.createdAt ?? ''),
    tags: r.tags,
  );
}
