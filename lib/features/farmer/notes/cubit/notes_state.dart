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

class NotesLoaded extends NotesState {
  const NotesLoaded(this.notes);
  final List<Note> notes;
  @override
  List<Object?> get props => [notes];
}

class NotesFailure extends NotesState {
  const NotesFailure();
}
