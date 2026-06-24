/// A selectable rating tag from the backend catalog. Stored on a rating as the
/// language-independent [key]; [en]/[ne] are display labels the client picks
/// between based on the active locale.
class RatingTag {
  const RatingTag({required this.key, required this.en, required this.ne});

  final String key;
  final String en;
  final String ne;

  factory RatingTag.fromJson(Map<String, dynamic> json) {
    final key = '${json['key'] ?? ''}';
    return RatingTag(
      key: key,
      en: '${json['en'] ?? key}',
      ne: '${json['ne'] ?? json['en'] ?? key}',
    );
  }

  /// Label for the given language code ('ne' → Nepali, else English).
  String label(String languageCode) => languageCode == 'ne' ? ne : en;
}
