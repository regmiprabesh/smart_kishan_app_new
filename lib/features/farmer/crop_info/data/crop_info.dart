import 'dart:convert';
import 'package:smart_kishan/shared/models/multilingual_field.dart';

/// A crop's reference info: image, multilingual name + description, and an
/// ordered list of cultivation activities (each multilingual). Shown in the
/// crop grid + detail page. Read-only reference data from the backend.
class CropInfo {
  const CropInfo({
    this.id,
    this.image,
    this.name,
    this.description,
    this.activities = const [],
    this.cropCategoryId,
    this.order,
  });

  final int? id;
  final String? image; // full URL (backend accessor)
  final MultilingualField? name;
  final MultilingualField? description;
  final List<CropActivity> activities;
  final int? cropCategoryId;
  final int? order;

  factory CropInfo.fromJson(Map<String, dynamic> json) {
    // name/description may arrive as a Map or a JSON string.
    MultilingualField? ml(dynamic raw) {
      if (raw == null) return null;
      if (raw is Map) {
        return MultilingualField.fromJson(Map<String, dynamic>.from(raw));
      }
      if (raw is String) {
        try {
          return MultilingualField.fromJson(
            Map<String, dynamic>.from(jsonDecode(raw)),
          );
        } catch (_) {
          return MultilingualField.fromJson({'en': raw, 'ne': raw});
        }
      }
      return null;
    }

    final rawActivity = json['activity'];
    List<CropActivity> acts = const [];
    if (rawActivity is List) {
      acts = rawActivity
          .whereType<Map<String, dynamic>>()
          .map(CropActivity.fromJson)
          .toList();
    } else if (rawActivity is String) {
      try {
        final decoded = jsonDecode(rawActivity);
        if (decoded is List) {
          acts = decoded
              .whereType<Map<String, dynamic>>()
              .map(CropActivity.fromJson)
              .toList();
        }
      } catch (_) {}
    }

    return CropInfo(
      id: json['id'] as int?,
      image: json['image'] as String?,
      name: ml(json['name']),
      description: ml(json['description']),
      activities: acts,
      cropCategoryId: json['crop_category_id'] as int?,
      order: json['order'] as int?,
    );
  }
}

/// One cultivation step (e.g. Sowing, Watering) — multilingual title + body.
class CropActivity {
  const CropActivity({this.title, this.description});

  final MultilingualField? title;
  final MultilingualField? description;

  factory CropActivity.fromJson(Map<String, dynamic> json) {
    MultilingualField? ml(dynamic raw) {
      if (raw == null) return null;
      if (raw is Map) {
        return MultilingualField.fromJson(Map<String, dynamic>.from(raw));
      }
      if (raw is String) {
        try {
          return MultilingualField.fromJson(
            Map<String, dynamic>.from(jsonDecode(raw)),
          );
        } catch (_) {
          return MultilingualField.fromJson({'en': raw, 'ne': raw});
        }
      }
      return null;
    }

    return CropActivity(
      title: ml(json['title']),
      description: ml(json['description']),
    );
  }
}
