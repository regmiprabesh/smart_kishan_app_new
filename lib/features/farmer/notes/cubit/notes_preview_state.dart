// notes_preview_state.dart
import 'package:equatable/equatable.dart';
import 'package:smart_kishan/features/farmer/notes/data/note.dart';

sealed class NotesPreviewState extends Equatable {
  const NotesPreviewState();
  @override
  List<Object?> get props => [];
}

class NotesPreviewLoading extends NotesPreviewState {
  const NotesPreviewLoading();
}

class NotesPreviewLoaded extends NotesPreviewState {
  const NotesPreviewLoaded(this.notes);
  final List<Note> notes;

  @override
  List<Object?> get props => [notes];
}

class NotesPreviewFailure extends NotesPreviewState {
  const NotesPreviewFailure();
}
