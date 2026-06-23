import 'review.dart';

/// Outcome of a rate/delete action, so callers can show the right feedback.
enum RatingMutationResult { submitted, updated, deleted, failed }

/// The data contract every rateable feature implements (one small adapter per
/// feature). Keeps the shared cubit/UI free of any feature-specific models or
/// endpoints.
abstract class RatingsRepository {
  Future<List<Review>> fetchReviews();
  Future<Review?> fetchMyReview();
  Future<void> submitReview({
    required int rating,
    String? text,
    required List<String> tags,
  });
  Future<void> deleteMyReview();
}
