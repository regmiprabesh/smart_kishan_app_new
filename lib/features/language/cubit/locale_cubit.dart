import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_kishan/core/services/local_storage_service.dart';

/// The ONLY place that reads, changes, or persists the app language.
/// MaterialApp rebuilds via BlocBuilder(<LocaleCubit, Locale>) in app.dart —
/// instant switch, persisted, and the saved value is read synchronously
/// at startup (storage is initialized before runApp), so no flicker.
class LocaleCubit extends Cubit<Locale> {
  LocaleCubit(this._storage) : super(_initial(_storage));

  final LocalStorageService _storage;

  static const Locale fallback = Locale('ne');
  static const List<Locale> supported = [Locale('en'), Locale('ne')];

  static Locale _initial(LocalStorageService storage) {
    final saved = storage.getLanguageCode();
    if (saved != null && supported.any((l) => l.languageCode == saved)) {
      return Locale(saved);
    }
    return fallback;
  }

  Future<void> changeLocale(String languageCode) async {
    if (!supported.any((l) => l.languageCode == languageCode)) return;
    if (languageCode == state.languageCode) return;
    await _storage.saveLanguageCode(languageCode);
    emit(Locale(languageCode));
  }

  bool get isNepali => state.languageCode == 'ne';
}
