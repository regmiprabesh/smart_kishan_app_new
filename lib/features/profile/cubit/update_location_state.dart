import 'package:equatable/equatable.dart';
import 'package:smart_kishan/shared/models/location.dart';

/// One-shot signal the screen listens for (snackbar + pop on success).
enum UpdateLocationOutcome { none, success, failure }

/// Distinguishes "leave a field untouched" from "explicitly set it to null"
/// in [UpdateLocationState.copyWith] — needed when selecting a parent clears
/// its children.
const Object _unset = Object();

/// Form state for the cascading province → district → municipality → ward
/// picker. A single immutable snapshot: the options loaded so far, the current
/// selection, per-field loading flags, and submit status.
class UpdateLocationState extends Equatable {
  const UpdateLocationState({
    this.provinces = const [],
    this.districts = const [],
    this.municipalities = const [],
    this.wards = const [],
    this.provinceId,
    this.districtId,
    this.municipalityId,
    this.wardId,
    this.loadingProvinces = false,
    this.loadingDistricts = false,
    this.loadingMunicipalities = false,
    this.loadingWards = false,
    this.submitting = false,
    this.outcome = UpdateLocationOutcome.none,
  });

  final List<Province> provinces;
  final List<District> districts;
  final List<Municipality> municipalities;
  final List<Ward> wards;

  final int? provinceId;
  final int? districtId;
  final int? municipalityId;
  final int? wardId;

  final bool loadingProvinces;
  final bool loadingDistricts;
  final bool loadingMunicipalities;
  final bool loadingWards;

  final bool submitting;
  final UpdateLocationOutcome outcome;

  UpdateLocationState copyWith({
    List<Province>? provinces,
    List<District>? districts,
    List<Municipality>? municipalities,
    List<Ward>? wards,
    Object? provinceId = _unset,
    Object? districtId = _unset,
    Object? municipalityId = _unset,
    Object? wardId = _unset,
    bool? loadingProvinces,
    bool? loadingDistricts,
    bool? loadingMunicipalities,
    bool? loadingWards,
    bool? submitting,
    UpdateLocationOutcome? outcome,
  }) {
    return UpdateLocationState(
      provinces: provinces ?? this.provinces,
      districts: districts ?? this.districts,
      municipalities: municipalities ?? this.municipalities,
      wards: wards ?? this.wards,
      provinceId: provinceId == _unset ? this.provinceId : provinceId as int?,
      districtId: districtId == _unset ? this.districtId : districtId as int?,
      municipalityId: municipalityId == _unset
          ? this.municipalityId
          : municipalityId as int?,
      wardId: wardId == _unset ? this.wardId : wardId as int?,
      loadingProvinces: loadingProvinces ?? this.loadingProvinces,
      loadingDistricts: loadingDistricts ?? this.loadingDistricts,
      loadingMunicipalities:
          loadingMunicipalities ?? this.loadingMunicipalities,
      loadingWards: loadingWards ?? this.loadingWards,
      submitting: submitting ?? this.submitting,
      outcome: outcome ?? this.outcome,
    );
  }

  @override
  List<Object?> get props => [
    provinces,
    districts,
    municipalities,
    wards,
    provinceId,
    districtId,
    municipalityId,
    wardId,
    loadingProvinces,
    loadingDistricts,
    loadingMunicipalities,
    loadingWards,
    submitting,
    outcome,
  ];
}
