import 'package:smart_kishan/shared/ratings/ratings_repository.dart';
import 'package:smart_kishan/shared/ratings/review.dart';

import 'service_center.dart';
import 'service_center_repository.dart';

/// Adapts the service-centers API to the shared [RatingsRepository] so service
/// centers reuse the core ratings section / reviews page / rate page.
///
/// Reviews are embedded in the center detail, so the screen seeds the cubit
/// from the already-loaded center (no fetch on open); these methods are used
/// to refresh after a write. Service-center ratings have no tags.
class ServiceCenterRatingsRepository implements RatingsRepository {
  ServiceCenterRatingsRepository(this._repo, this.serviceCenterId);

  final ServiceCenterRepository _repo;
  final int serviceCenterId;

  @override
  Future<List<Review>> fetchReviews() async {
    final center = await _repo.fetchServiceCenter(serviceCenterId);
    return (center.ratings ?? const []).map(toReview).toList();
  }

  @override
  Future<Review?> fetchMyReview() async {
    final r = await _repo.fetchUserRating(serviceCenterId);
    return r == null ? null : toReview(r);
  }

  @override
  Future<void> submitReview({
    required int rating,
    String? text,
    required List<String> tags,
  }) => _repo.rate(
    serviceCenterId: serviceCenterId,
    rating: rating,
    review: text,
  );

  @override
  Future<void> deleteMyReview() => _repo.deleteRating(serviceCenterId);

  /// Maps a service-center rating onto the generic [Review]. Static so the
  /// detail screen can seed the cubit from the loaded center.
  static Review toReview(ServiceCenterRating r) => Review(
    id: r.id,
    userName: r.userName,
    rating: r.rating,
    text: r.review,
    createdAt: r.createdAt,
  );
}
