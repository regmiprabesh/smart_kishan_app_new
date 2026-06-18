import 'package:smart_kishan/shared/models/multilingual_field.dart';

class RecommendedCrops {
  const RecommendedCrops({this.vegetables = const [], this.fruits = const []});

  final List<RecommendedCrop> vegetables;
  final List<RecommendedCrop> fruits;

  bool get isEmpty => vegetables.isEmpty && fruits.isEmpty;

  factory RecommendedCrops.fromJson(Map<String, dynamic> json) {
    List<RecommendedCrop> parse(String key) {
      final list = json[key];
      if (list is! List) return const [];
      return list
          .whereType<Map<String, dynamic>>()
          .map(RecommendedCrop.fromJson)
          .toList();
    }

    return RecommendedCrops(
      vegetables: parse('vegetables'),
      fruits: parse('fruits'),
    );
  }
}

class RecommendedCrop {
  const RecommendedCrop({required this.name, this.season, this.description});

  final MultilingualField? name;
  final String? season;
  final String? description;

  factory RecommendedCrop.fromJson(Map<String, dynamic> json) {
    return RecommendedCrop(
      name: MultilingualField.fromJson(json['name']),
      season: json['season']?.toString(),
      description: json['description']?.toString(),
    );
  }
}
