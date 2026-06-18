import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/crop_info.dart';
import '../data/crop_info_repository.dart';
import 'crop_info_state.dart';

/// Loads crops and holds a search query. Search filters by name (en/ne).
class CropInfoCubit extends Cubit<CropInfoState> {
  CropInfoCubit(this._repository) : super(const CropInfoLoading());
  final CropInfoRepository _repository;

  Future<void> load() async {
    emit(const CropInfoLoading());
    try {
      final crops = await _repository.fetchCrops();
      emit(CropInfoLoaded(crops: crops));
    } catch (e) {
      debugPrint('Crops load failed: $e');
      emit(const CropInfoFailure());
    }
  }

  void search(String query) {
    final s = state;
    if (s is CropInfoLoaded) emit(s.copyWith(query: query));
  }

  /// Crops filtered by the current query (matches en/ne name).
  List<CropInfo> filtered(CropInfoLoaded state) {
    final q = state.query.trim().toLowerCase();
    if (q.isEmpty) return state.crops;
    return state.crops.where((c) {
      final en = (c.name?.en ?? '').toLowerCase();
      final ne = (c.name?.ne ?? '').toLowerCase();
      return en.contains(q) || ne.contains(q);
    }).toList();
  }
}
