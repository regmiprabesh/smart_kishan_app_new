import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/farmland.dart';
import '../data/farmland_repository.dart';
import '../data/soil_data.dart';
import 'farmland_state.dart';

/// Owns the farmland list + CRUD (multipart image upload). Mutations are
/// optimistic and return bool for the form. Also exposes soil lookup, which
/// the add/edit screen uses to auto-fill soil properties.
class FarmlandCubit extends Cubit<FarmlandState> {
  FarmlandCubit(this._repository) : super(const FarmlandLoading());

  final FarmlandRepository _repository;

  List<Farmland> get _items => state is FarmlandLoaded
      ? List.of((state as FarmlandLoaded).farmlands)
      : [];

  Future<void> load() async {
    emit(const FarmlandLoading());
    try {
      final list = await _repository.fetchFarmlands();
      emit(FarmlandLoaded(list));
    } catch (e) {
      debugPrint('Farmlands load failed: $e');
      emit(const FarmlandFailure());
    }
  }

  Future<bool> add(
    Farmland farmland, {
    String? imagePath,
    void Function(double)? onProgress,
  }) async {
    try {
      final created = await _repository.addFarmland(
        farmland,
        imagePath: imagePath,
        onSendProgress: (sent, total) =>
            total > 0 ? onProgress?.call(sent / total) : null,
      );
      emit(FarmlandLoaded([created, ..._items]));
      return true;
    } catch (e) {
      debugPrint('Farmland add failed: $e');
      return false;
    }
  }

  Future<bool> update(
    Farmland farmland, {
    String? imagePath,
    bool removeImage = false,
    void Function(double)? onProgress,
  }) async {
    try {
      final updated = await _repository.updateFarmland(
        farmland,
        imagePath: imagePath,
        removeImage: removeImage,
        onSendProgress: (sent, total) {
          if (total > 0) onProgress?.call(sent / total);
        },
      );
      emit(
        FarmlandLoaded(
          _items.map((f) => f.id == updated.id ? updated : f).toList(),
        ),
      );
      return true;
    } catch (e) {
      debugPrint('Farmland update failed: $e');
      return false;
    }
  }

  Future<bool> delete(int id) async {
    try {
      await _repository.deleteFarmland(id);
      emit(FarmlandLoaded(_items.where((f) => f.id != id).toList()));
      return true;
    } catch (e) {
      debugPrint('Farmland delete failed: $e');
      return false;
    }
  }

  /// Soil lookup for the add/edit screen's "auto-fetch" button.
  Future<SoilData?> fetchSoil(double lat, double lng) =>
      _repository.fetchSoil(lat, lng);
}
