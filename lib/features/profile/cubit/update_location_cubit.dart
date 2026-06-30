import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_kishan/features/auth/cubit/session_cubit.dart';
import 'package:smart_kishan/features/profile/cubit/update_location_state.dart';
import 'package:smart_kishan/features/profile/data/location_repository.dart';

/// Drives the cascading location picker. Loads provinces on [init] (preselecting
/// and cascading down from the user's saved location if any), reloads each child
/// list when its parent changes, and on [submit] persists the choice and
/// refreshes the global session so the rest of the app sees the new location.
class UpdateLocationCubit extends Cubit<UpdateLocationState> {
  UpdateLocationCubit(this._repo, this._session)
    : super(const UpdateLocationState());

  final LocationRepository _repo;
  final SessionCubit _session;

  /// Load provinces; the user selects their location fresh.
  Future<void> init() async {
    await _loadProvinces();
  }

  Future<void> selectProvince(int? id) async {
    emit(
      state.copyWith(
        provinceId: id,
        districtId: null,
        municipalityId: null,
        wardId: null,
        districts: const [],
        municipalities: const [],
        wards: const [],
      ),
    );
    if (id != null) await _loadDistricts(id);
  }

  Future<void> selectDistrict(int? id) async {
    emit(
      state.copyWith(
        districtId: id,
        municipalityId: null,
        wardId: null,
        municipalities: const [],
        wards: const [],
      ),
    );
    if (id != null) await _loadMunicipalities(id);
  }

  Future<void> selectMunicipality(int? id) async {
    emit(state.copyWith(municipalityId: id, wardId: null, wards: const []));
    if (id != null) await _loadWards(id);
  }

  void selectWard(int? id) => emit(state.copyWith(wardId: id));

  Future<void> submit({String? address}) async {
    if (state.submitting) return;
    final p = state.provinceId;
    final d = state.districtId;
    final m = state.municipalityId;
    final w = state.wardId;
    if (p == null || d == null || m == null || w == null) return;

    emit(state.copyWith(submitting: true, outcome: UpdateLocationOutcome.none));
    try {
      final user = await _repo.updateLocation(
        provinceId: p,
        districtId: d,
        municipalityId: m,
        wardId: w,
        address: address,
      );
      _session.refreshUser(user);
      if (isClosed) return;
      emit(
        state.copyWith(
          submitting: false,
          outcome: UpdateLocationOutcome.success,
        ),
      );
    } catch (e) {
      debugPrint('Update location failed: $e');
      if (isClosed) return;
      emit(
        state.copyWith(
          submitting: false,
          outcome: UpdateLocationOutcome.failure,
        ),
      );
    }
  }

  Future<void> _loadProvinces() async {
    emit(state.copyWith(loadingProvinces: true));
    try {
      final v = await _repo.fetchProvinces();
      if (isClosed) return;
      emit(state.copyWith(provinces: v, loadingProvinces: false));
    } catch (e) {
      debugPrint('Load provinces failed: $e');
      if (isClosed) return;
      emit(state.copyWith(loadingProvinces: false));
    }
  }

  Future<void> _loadDistricts(int provinceId) async {
    emit(state.copyWith(loadingDistricts: true));
    try {
      final v = await _repo.fetchDistricts(provinceId);
      if (isClosed) return;
      emit(state.copyWith(districts: v, loadingDistricts: false));
    } catch (e) {
      debugPrint('Load districts failed: $e');
      if (isClosed) return;
      emit(state.copyWith(loadingDistricts: false));
    }
  }

  Future<void> _loadMunicipalities(int districtId) async {
    emit(state.copyWith(loadingMunicipalities: true));
    try {
      final v = await _repo.fetchMunicipalities(districtId);
      if (isClosed) return;
      emit(state.copyWith(municipalities: v, loadingMunicipalities: false));
    } catch (e) {
      debugPrint('Load municipalities failed: $e');
      if (isClosed) return;
      emit(state.copyWith(loadingMunicipalities: false));
    }
  }

  Future<void> _loadWards(int municipalityId) async {
    emit(state.copyWith(loadingWards: true));
    try {
      final v = await _repo.fetchWards(municipalityId);
      if (isClosed) return;
      emit(state.copyWith(wards: v, loadingWards: false));
    } catch (e) {
      debugPrint('Load wards failed: $e');
      if (isClosed) return;
      emit(state.copyWith(loadingWards: false));
    }
  }
}
