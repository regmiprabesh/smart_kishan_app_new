import 'package:equatable/equatable.dart';
import 'package:smart_kishan/features/farmer/notes/data/note.dart';

sealed class NotesState extends Equatable {
  const NotesState();
  @override
  List<Object?> get props => [];
}

class NotesLoading extends NotesState {
  const NotesLoading();
}

// notes_state.dart
class NotesLoaded extends NotesState {
  const NotesLoaded({
    required this.notes, // current view: search results if searching, else top notes
    required this.topNotes, // always unfiltered, priority-sorted — dashboard preview reads this
    this.query = '',
    this.page = 1,
    this.lastPage = 1,
    this.loadingMore = false,
  });

  final List<Note> notes;
  final List<Note> topNotes;
  final String query;
  final int page;
  final int lastPage;
  final bool loadingMore;

  bool get hasMore => page < lastPage;

  NotesLoaded copyWith({
    List<Note>? notes,
    List<Note>? topNotes,
    String? query,
    int? page,
    int? lastPage,
    bool? loadingMore,
  }) {
    return NotesLoaded(
      notes: notes ?? this.notes,
      topNotes: topNotes ?? this.topNotes,
      query: query ?? this.query,
      page: page ?? this.page,
      lastPage: lastPage ?? this.lastPage,
      loadingMore: loadingMore ?? this.loadingMore,
    );
  }

  @override
  List<Object?> get props => [
    notes,
    topNotes,
    query,
    page,
    lastPage,
    loadingMore,
  ];
}

class NotesFailure extends NotesState {
  const NotesFailure();
}
