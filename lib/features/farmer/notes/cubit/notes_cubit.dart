import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_kishan/features/farmer/notes/cubit/notes_state.dart';
import 'package:smart_kishan/features/farmer/notes/data/note.dart';
import 'package:smart_kishan/features/farmer/notes/data/note_repository.dart';

class NotesCubit extends Cubit<NotesState> {
  NotesCubit(this._repository) : super(const NotesLoading());

  final NoteRepository _repository;
  Timer? _debounce;
  String _query = '';
  bool _hasLoadedOnce = false;

  NotesLoaded? get _loaded =>
      state is NotesLoaded ? state as NotesLoaded : null;

  bool get hasLoadedOnce => _hasLoadedOnce;

  /// First page (also used by pull-to-refresh and after search/debounce).
  Future<void> load() async {
    final prev = _loaded;
    emit(const NotesLoading());
    try {
      final res = await _repository.fetchNotes(page: 1, search: _query);
      final sorted = _sorted(res.items);
      _hasLoadedOnce = true;
      emit(
        NotesLoaded(
          notes: sorted,
          topNotes: _query.isEmpty
              ? sorted.take(2).toList()
              : (prev?.topNotes ?? const []),
          query: _query,
          page: res.page,
          lastPage: res.lastPage,
        ),
      );
    } catch (e) {
      debugPrint('Notes load failed: $e');
      emit(const NotesFailure());
    }
  }

  /// Debounced server-side search — resets to page 1.
  void search(String query) {
    _query = query.trim();
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), load);
  }

  /// Append the next page (called when the list nears its end).
  Future<void> loadMore() async {
    final s = _loaded;
    if (s == null || !s.hasMore || s.loadingMore) return;
    emit(s.copyWith(loadingMore: true));
    try {
      final res = await _repository.fetchNotes(
        page: s.page + 1,
        search: _query,
      );
      emit(
        s.copyWith(
          notes: _sorted([...s.notes, ...res.items]),
          page: res.page,
          lastPage: res.lastPage,
          loadingMore: false,
        ),
      );
    } catch (e) {
      debugPrint('Notes loadMore failed: $e');
      emit(s.copyWith(loadingMore: false));
    }
  }

  bool _matchesQuery(Note note, String query) {
    if (query.isEmpty) return true;
    final q = query.toLowerCase();
    final title = note.title?.toLowerCase() ?? '';
    final desc = note.description?.toLowerCase() ?? '';
    return title.contains(q) || desc.contains(q);
  }

  Future<bool> add(Note note) async {
    try {
      final created = await _repository.addNote(note);
      final s = _loaded;
      if (s != null) {
        final updatedNotes = _matchesQuery(created, _query)
            ? _sorted([...s.notes, created])
            : s.notes;
        emit(
          s.copyWith(
            notes: updatedNotes,
            topNotes: _sorted([...s.topNotes, created]).take(2).toList(),
          ),
        );
      }
      return true;
    } catch (e) {
      debugPrint('Note add failed: $e');
      return false;
    }
  }

  Future<bool> update(Note note) async {
    try {
      final updated = await _repository.updateNote(note);
      final s = _loaded;
      if (s != null) {
        final updatedNotes = _query.isEmpty || _matchesQuery(updated, _query)
            ? _sorted([
                for (final n in s.notes)
                  if (n.id != updated.id) n,
                updated,
              ])
            // No longer matches the active search — drop it from the view.
            : s.notes.where((n) => n.id != updated.id).toList();

        final candidatePool = _query.isEmpty
            ? updatedNotes
            : [
                for (final n in s.topNotes) n.id == updated.id ? updated : n,
                if (!s.topNotes.any((n) => n.id == updated.id)) updated,
              ];

        emit(
          s.copyWith(
            notes: updatedNotes,
            topNotes: _sorted(candidatePool).take(2).toList(),
          ),
        );
      }
      return true;
    } catch (e) {
      debugPrint('Note update failed: $e');
      return false;
    }
  }

  Future<bool> delete(int id) async {
    try {
      await _repository.deleteNote(id);
      final s = _loaded;
      if (s != null) {
        final updatedNotes = s.notes.where((n) => n.id != id).toList();

        final candidatePool = _query.isEmpty
            ? updatedNotes
            : s.topNotes.where((n) => n.id != id).toList();
        final updatedTop = _sorted(candidatePool).take(2).toList();

        emit(s.copyWith(notes: updatedNotes, topNotes: updatedTop));
      }
      return true;
    } catch (e) {
      debugPrint('Note delete failed: $e');
      return false;
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }

  /// Lower priority number first; nulls last (matches the original sort).
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
