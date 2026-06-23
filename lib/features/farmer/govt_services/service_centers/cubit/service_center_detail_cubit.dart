import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/service_center_repository.dart';
import 'service_center_detail_state.dart';

/// Loads a single service center for the detail screen. Ratings are handled by
/// the shared [RatingsCubit] (seeded from the loaded center), so this cubit
/// only owns the fetch.
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
}
