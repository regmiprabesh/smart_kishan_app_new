import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_kishan/features/farmer/notes/cubit/notes_state.dart';
import 'package:smart_kishan/features/farmer/notes/data/note.dart';
import 'package:smart_kishan/features/farmer/notes/data/note_repository.dart';

class NotesCubit extends Cubit<NotesState> {
  NotesCubit(this._repository) : super(const NotesLoading());

  final NoteRepository _repository;

  List<Note> get _current =>
      state is NotesLoaded ? List.of((state as NotesLoaded).notes) : [];

  Future<void> load() async {
    emit(const NotesLoading());
    try {
      final notes = await _repository.fetchNotes();
      emit(NotesLoaded(_sorted(notes)));
    } catch (e) {
      debugPrint('Notes load failed: $e');
      emit(const NotesFailure());
    }
  }

  Future<bool> add(Note note) async {
    try {
      final created = await _repository.addNote(note);
      emit(NotesLoaded(_sorted([..._current, created])));
      return true;
    } catch (e) {
      debugPrint('Note add failed: $e');
      return false;
    }
  }

  Future<bool> update(Note note) async {
    try {
      final updated = await _repository.updateNote(note);
      final list = _current
          .map((n) => n.id == updated.id ? updated : n)
          .toList();
      emit(NotesLoaded(_sorted(list)));
      return true;
    } catch (e) {
      debugPrint('Note update failed: $e');
      return false;
    }
  }

  Future<bool> delete(int id) async {
    try {
      await _repository.deleteNote(id);
      emit(NotesLoaded(_current.where((n) => n.id != id).toList()));
      return true;
    } catch (e) {
      debugPrint('Note delete failed: $e');
      return false;
    }
  }

  /// Lower priority number first; nulls last (matches the old sort).
  List<Note> _sorted(List<Note> notes) {
    final list = List.of(notes);
    list.sort((a, b) {
      if (a.priority == null && b.priority == null) return 0;
      if (a.priority == null) return 1;
      if (b.priority == null) return -1;
      return a.priority!.compareTo(b.priority!);
    });
    return list;
  }
}
