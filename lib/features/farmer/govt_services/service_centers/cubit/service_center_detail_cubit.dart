import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/service_center.dart';
import '../data/service_center_repository.dart';
import 'service_center_detail_state.dart';

/// Outcome of a rate/delete action, so the screen can show the right snackbar.
enum RatingActionResult { submitted, updated, deleted, failed }

class ServiceCenterDetailCubit extends Cubit<ServiceCenterDetailState> {
  ServiceCenterDetailCubit(this._repo, this.serviceCenterId)
      : super(const ServiceCenterDetailLoading());

  final ServiceCenterRepository _repo;
  final int serviceCenterId;

  Future<void> load() async {
    emit(const ServiceCenterDetailLoading());
    try {
      final center = await _repo.fetchServiceCenter(serviceCenterId);
      emit(ServiceCenterDetailLoaded(center: center));
    } catch (e) {
      emit(ServiceCenterDetailFailure(e.toString()));
    }
  }

  /// Submit or edit the user's rating. Updates local aggregate so the UI
  /// reflects the change without a refetch (consistent with our write-returns-
  /// entity convention).
  Future<RatingActionResult> submitRating({
    required int rating,
    String? review,
  }) async {
    final s = state;
    if (s is! ServiceCenterDetailLoaded) return RatingActionResult.failed;

    final wasRated = s.center.userRating != null;
    emit(s.copyWith(submittingRating: true));
    try {
      final saved = await _repo.rate(
        serviceCenterId: serviceCenterId,
        rating: rating,
        review: review,
      );
      final updated = _withUserRating(s.center, saved, wasRated: wasRated);
      emit(ServiceCenterDetailLoaded(center: updated));
      return wasRated ? RatingActionResult.updated : RatingActionResult.submitted;
    } catch (_) {
      emit(s.copyWith(submittingRating: false));
      return RatingActionResult.failed;
    }
  }

  Future<RatingActionResult> deleteRating() async {
    final s = state;
    if (s is! ServiceCenterDetailLoaded) return RatingActionResult.failed;
    if (s.center.userRating == null) return RatingActionResult.failed;

    emit(s.copyWith(submittingRating: true));
    try {
      await _repo.deleteRating(serviceCenterId);
      final updated = _withoutUserRating(s.center);
      emit(ServiceCenterDetailLoaded(center: updated));
      return RatingActionResult.deleted;
    } catch (_) {
      emit(s.copyWith(submittingRating: false));
      return RatingActionResult.failed;
    }
  }

  // ── local aggregate recompute ───────────────────────────────────────────
  // The list of recent reviews + average/count are updated in place so the
  // detail screen stays correct after a write. A full refetch would also work
  // but this avoids the round-trip and the flicker.

  ServiceCenter _withUserRating(
    ServiceCenter center,
    ServiceCenterRating saved, {
    required bool wasRated,
  }) {
    final ratings = List<ServiceCenterRating>.from(center.ratings ?? const []);
    final idx = ratings.indexWhere((r) => r.id == saved.id || r.userId == saved.userId);
    if (idx >= 0) {
      ratings[idx] = saved;
    } else {
      ratings.insert(0, saved);
    }

    final count = wasRated ? (center.totalRatings ?? ratings.length) : (center.totalRatings ?? 0) + 1;
    final avg = _average(ratings, fallbackCount: count);

    return center.copyWith(
      userRating: saved,
      ratings: ratings,
      totalRatings: count,
      averageRating: avg,
    );
  }

  ServiceCenter _withoutUserRating(ServiceCenter center) {
    final ratings = List<ServiceCenterRating>.from(center.ratings ?? const [])
      ..removeWhere((r) => r.id == center.userRating?.id);
    final count = ((center.totalRatings ?? 1) - 1).clamp(0, 1 << 31);
    final avg = count == 0 ? 0.0 : _average(ratings, fallbackCount: count);
    return center.copyWith(
      clearUserRating: true,
      ratings: ratings,
      totalRatings: count,
      averageRating: avg,
    );
  }

  double _average(List<ServiceCenterRating> ratings, {required int fallbackCount}) {
    if (ratings.isEmpty) return 0;
    final sum = ratings.fold<int>(0, (a, r) => a + r.rating);
    return sum / ratings.length;
  }
}
