import 'package:smart_kishan/features/farmer/notes/cubit/notes_cubit.dart';
import 'package:smart_kishan/features/farmer/notes/data/note.dart';

class NoteArgs {
  const NoteArgs({required this.cubit, this.note});
  final NotesCubit cubit;
  final Note? note;
}
