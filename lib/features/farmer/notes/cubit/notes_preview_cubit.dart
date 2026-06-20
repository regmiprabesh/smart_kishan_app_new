// notes_preview_cubit.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_kishan/features/farmer/notes/cubit/notes_preview_state.dart';
import 'package:smart_kishan/features/farmer/notes/data/note_repository.dart';

/// Drives the dashboard's "top notes" preview only.
/// Independent of NotesCubit (which backs the searchable list screen),
/// so a search on that screen never affects what's shown here.
class NotesPreviewCubit extends Cubit<NotesPreviewState> {
  NotesPreviewCubit(this._repository) : super(const NotesPreviewLoading());

  final NoteRepository _repository;
  static const _previewCount = 2;

  Future<void> load() async {
    emit(const NotesPreviewLoading());
    try {
      // perPage: small page is enough since notes are already
      // priority-ordered server-side (NoteController orderBy('priority')).
      final res = await _repository.fetchNotes(page: 1, perPage: _previewCount);
      emit(NotesPreviewLoaded(res.items));
    } catch (e) {
      debugPrint('Notes preview load failed: $e');
      emit(const NotesPreviewFailure());
    }
  }

  /// Call after add/update/delete elsewhere so the preview stays fresh.
  void refresh() => load();
}
