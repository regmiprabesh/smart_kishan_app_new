import 'package:smart_kishan/core/constants/api_endpoints.dart';
import 'package:smart_kishan/core/network/api_client.dart';
import 'package:smart_kishan/core/network/page_result.dart';
import 'package:smart_kishan/features/farmer/notes/data/note.dart';

class NoteRepository {
  NoteRepository({required ApiClient api}) : _api = api;

  final ApiClient _api;

  /// GET /notes?page=&per_page=&search= — Laravel-paginated.
  Future<PageResult<Note>> fetchNotes({
    int page = 1,
    int perPage = 15,
    String? search,
  }) async {
    final res = await _api.get(
      ApiEndpoints.notes,
      query: {
        'page': '$page',
        'per_page': '$perPage',
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );
    final list = (res.data as List?) ?? const [];
    final meta = (res.body['meta'] as Map?) ?? const {};
    return PageResult(
      items: list.map((e) => Note.fromJson(e as Map<String, dynamic>)).toList(),
      page: (meta['current_page'] as int?) ?? page,
      lastPage: (meta['last_page'] as int?) ?? page,
    );
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

  Future<void> deleteNote(int id) => _api.delete(ApiEndpoints.note(id));
}
