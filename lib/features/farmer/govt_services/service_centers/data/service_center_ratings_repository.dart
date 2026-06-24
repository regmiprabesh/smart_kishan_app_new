import 'package:smart_kishan/shared/ratings/data/rating_aggregate.dart';
import 'package:smart_kishan/shared/ratings/data/ratings_repository.dart';
import 'package:smart_kishan/shared/ratings/data/review.dart';

import 'service_center.dart';
import 'service_center_repository.dart';

/// Adapts the service-centers API to the shared [RatingsRepository] so service
/// centers reuse the core ratings section / reviews page / rate page.
///
/// The detail screen seeds the cubit with a capped preview embedded in `show`
/// (no fetch on open). [fetchReviews] pulls the full paginated list from the
/// dedicated reviews endpoint — used by the "See all" page and to refresh after
/// a write. Service-center ratings have no tags.
class ServiceCenterRatingsRepository implements RatingsRepository {
  ServiceCenterRatingsRepository(this._repo, this.serviceCenterId);

  final ServiceCenterRepository _repo;
  final int serviceCenterId;

  @override
  Future<List<Review>> fetchReviews() async {
    final ratings = await _repo.fetchReviews(serviceCenterId);
    return ratings.map(toReview).toList();
  }

  @override
  Future<Review?> fetchMyReview() async {
    final r = await _repo.fetchUserRating(serviceCenterId);
    return r == null ? null : toReview(r);
  }

  @override
  Future<RatingAggregate> submitReview({
    required int rating,
    String? text,
    required List<String> tags,
  }) => _repo.rate(
    serviceCenterId: serviceCenterId,
    rating: rating,
    review: text,
    tags: tags,
  );

  @override
  Future<RatingAggregate> deleteMyReview() =>
      _repo.deleteRating(serviceCenterId);

  /// Maps a service-center rating onto the generic [Review]. Static so the
  /// detail screen can seed the cubit from the loaded center.
  static Review toReview(ServiceCenterRating r) => Review(
    id: r.id,
    userName: r.userName,
    rating: r.rating,
    text: r.review,
    createdAt: r.createdAt,
    tags: r.tags,
  );
}
