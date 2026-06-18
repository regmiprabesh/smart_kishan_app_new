import 'package:smart_kishan/core/constants/api_endpoints.dart';
import 'package:smart_kishan/core/network/api_client.dart';
import 'package:smart_kishan/features/farmer/notes/data/note.dart';

class NoteRepository {
  NoteRepository({required ApiClient api}) : _api = api;

  final ApiClient _api;

  Future<List<Note>> fetchNotes() async {
    final res = await _api.get(ApiEndpoints.notes);
    final list = (res.data as List?) ?? const [];
    return list.map((e) => Note.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Note> addNote(Note note) async {
    final res = await _api.post(ApiEndpoints.notes, body: note.toJson());
    return Note.fromJson(res.data as Map<String, dynamic>);
  }

  Future<Note> updateNote(Note note) async {
    final res = await _api.put(
      ApiEndpoints.note(note.id!),
      body: note.toJson(),
    );
    return Note.fromJson(res.data as Map<String, dynamic>);
  }

  Future<void> deleteNote(int id) {
    return _api.delete(ApiEndpoints.note(id));
  }
}
