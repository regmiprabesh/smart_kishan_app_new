import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_kishan/core/services/local_storage_service.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(this._storage) : super(_initial(_storage));

  final LocalStorageService _storage;

  static ThemeMode _initial(LocalStorageService storage) {
    return switch (storage.getThemeMode()) {
      'dark' => ThemeMode.dark,
      'light' => ThemeMode.light,
      _ => ThemeMode.system,
    };
  }

  Future<void> set(ThemeMode mode) async {
    await _storage.saveThemeMode(mode.name);
    emit(mode);
  }

  /// Debug/QA convenience: light → dark → system → light…
  Future<void> cycle() => set(switch (state) {
    ThemeMode.light => ThemeMode.dark,
    ThemeMode.dark => ThemeMode.system,
    ThemeMode.system => ThemeMode.light,
  });
}
