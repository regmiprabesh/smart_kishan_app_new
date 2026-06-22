import 'package:smart_kishan/shared/models/multilingual_field.dart';

/// A farmer's request for a NEW subsidy to be created. Status flows
/// pending → under_review → approved | rejected | converted (became a subsidy).
class SubsidyRequest {
  const SubsidyRequest({
    this.id,
    this.title,
    this.description,
    this.subsidyType,
    this.targetCropOrSector,
    this.justification,
    this.requestedToLevel,
    this.status,
    this.adminNotes,
    this.reviewedAt,
    this.subsidyId,
    this.createdAt,
  });

  final int? id;
  final MultilingualField? title;
  final MultilingualField? description;
  final String? subsidyType;
  final MultilingualField? targetCropOrSector;
  final MultilingualField? justification;

  /// central | province | district | municipality | ward
  final String? requestedToLevel;

  /// pending | under_review | approved | rejected | converted
  final String? status;
  final MultilingualField? adminNotes;
  final String? reviewedAt;

  /// Set once the request is converted into a real subsidy.
  final int? subsidyId;
  final String? createdAt;

  factory SubsidyRequest.fromJson(Map<String, dynamic> json) {
    MultilingualField? ml(dynamic v) =>
        v != null ? MultilingualField.fromJson(v) : null;
    return SubsidyRequest(
      id: json['id'],
      title: ml(json['title']),
      description: ml(json['description']),
      subsidyType: json['subsidy_type'],
      targetCropOrSector: ml(json['target_crop_or_sector']),
      justification: ml(json['justification']),
      requestedToLevel: json['requested_to_level'],
      status: json['status'],
      adminNotes: ml(json['admin_notes']),
      reviewedAt: json['reviewed_at'],
      subsidyId: json['subsidy_id'],
      createdAt: json['created_at'],
    );
  }
}
