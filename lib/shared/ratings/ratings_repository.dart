import 'rating_aggregate.dart';
import 'review.dart';

/// Outcome of a rate/delete action, so callers can show the right feedback.
enum RatingMutationResult { submitted, updated, deleted, failed }

/// The data contract every rateable feature implements (one small adapter per
/// feature). Keeps the shared cubit/UI free of any feature-specific models or
/// endpoints.
///
/// Writes return the server's recomputed [RatingAggregate] so the cubit can
/// adopt the authoritative average/total rather than recomputing locally.
abstract class RatingsRepository {
  Future<List<Review>> fetchReviews();
  Future<Review?> fetchMyReview();
  Future<RatingAggregate> submitReview({
    required int rating,
    String? text,
    required List<String> tags,
  });
  Future<RatingAggregate> deleteMyReview();
}
