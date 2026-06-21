import 'dart:convert';

import 'package:smart_kishan/shared/models/location.dart';
import 'package:smart_kishan/shared/models/multilingual_field.dart';

import 'application_form_field.dart';
import 'subsidy_document.dart';

/// A government subsidy the farmer can view, apply for, and rate.
///
/// The same model is returned by both the available-subsidies list and the
/// my-applications list; in the latter, [application] carries the farmer's
/// pivot data (status, notes, submitted form, uploaded docs).
class Subsidy {
  const Subsidy({
    this.id,
    this.title,
    this.description,
    this.subsidyType,
    this.targetCropOrSector,
    this.fiscalYear,
    this.expectedBeneficiaries,
    this.eligibilityCriteria,
    this.deadline,
    this.deadlineNepali,
    this.budgetPerBeneficiary,
    this.totalBudget,
    this.locationLevel,
    this.status,
    this.notes,
    this.province,
    this.district,
    this.municipality,
    this.ward,
    this.hasApplied = false,
    this.averageRating = 0,
    this.totalRatings = 0,
    this.userRating,
    this.requiredDocuments = const [],
    this.documents = const [],
    this.applicationFormFields = const [],
    this.application,
  });

  final int? id;
  final MultilingualField? title;
  final MultilingualField? description;

  /// fertilizer | equipment | training | irrigation | livestock | seeds | …
  final String? subsidyType;
  final MultilingualField? targetCropOrSector;
  final String? fiscalYear;
  final int? expectedBeneficiaries;
  final MultilingualField? eligibilityCriteria;

  /// ISO deadline (English calendar) + a pre-formatted Nepali string.
  final String? deadline;
  final String? deadlineNepali;
  final String? budgetPerBeneficiary;
  final String? totalBudget;

  /// central | province | district | municipality | ward
  final String? locationLevel;
  final String? status;
  final MultilingualField? notes;

  final Province? province;
  final District? district;
  final Municipality? municipality;
  final Ward? ward;

  final bool hasApplied;
  final double averageRating;
  final int totalRatings;
  final int? userRating;

  final List<RequiredDocument> requiredDocuments;
  final List<SubsidyDocument> documents;
  final List<ApplicationFormField> applicationFormFields;

  /// Present only when this subsidy came from the my-applications list.
  final SubsidyApplicationInfo? application;

  /// Deadline has passed (closed for new applications).
  bool get isExpired {
    if (deadline == null) return false;
    final d = DateTime.tryParse(deadline!);
    if (d == null) return false;
    return d.isBefore(DateTime.now());
  }

  factory Subsidy.fromJson(Map<String, dynamic> json) {
    return Subsidy(
      id: json['id'],
      title: MultilingualField.fromJson(json['title']),
      description: MultilingualField.fromJson(json['description']),
      subsidyType: json['subsidy_type'],
      targetCropOrSector:
          MultilingualField.fromJson(json['target_crop_or_sector']),
      fiscalYear: json['fiscal_year'],
      expectedBeneficiaries: json['expected_beneficiaries'],
      eligibilityCriteria:
          MultilingualField.fromJson(json['eligibility_criteria']),
      deadline: json['deadline'],
      deadlineNepali: json['deadline_nepali'],
      budgetPerBeneficiary: json['budget_per_beneficiary']?.toString(),
      totalBudget: json['total_budget']?.toString(),
      locationLevel: json['location_level'],
      status: json['status'],
      notes: MultilingualField.fromJson(json['notes']),
      province:
          json['province'] != null ? Province.fromJson(json['province']) : null,
      district:
          json['district'] != null ? District.fromJson(json['district']) : null,
      municipality: json['municipality'] != null
          ? Municipality.fromJson(json['municipality'])
          : null,
      ward: json['ward'] != null ? Ward.fromJson(json['ward']) : null,
      hasApplied: json['has_applied'] ?? false,
      averageRating: double.tryParse('${json['average_rating'] ?? 0}') ?? 0,
      totalRatings: int.tryParse('${json['total_ratings'] ?? 0}') ?? 0,
      userRating: json['user_rating'] != null
          ? int.tryParse('${json['user_rating']}')
          : null,
      requiredDocuments:
          _mapList(json['required_documents'], RequiredDocument.fromJson),
      documents: _mapList(json['documents'], SubsidyDocument.fromJson),
      applicationFormFields: _mapList(
          json['application_form_fields'], ApplicationFormField.fromJson),
      application: json['pivot'] is Map
          ? SubsidyApplicationInfo.fromPivot(
              Map<String, dynamic>.from(json['pivot'] as Map))
          : null,
    );
  }
}

/// The farmer's application pivot for a subsidy (my-applications list/detail).
class SubsidyApplicationInfo {
  const SubsidyApplicationInfo({
    this.status,
    this.notes,
    this.appliedAt,
    this.reviewedAt,
    this.reviewedBy,
    this.documents = const [],
    this.formData = const {},
  });

  /// pending | under_review | approved | rejected
  final String? status;
  final String? notes;
  final String? appliedAt;
  final String? reviewedAt;
  final int? reviewedBy;
  final List<dynamic> documents;
  final Map<String, dynamic> formData;

  factory SubsidyApplicationInfo.fromPivot(Map<String, dynamic> pivot) {
    return SubsidyApplicationInfo(
      status: pivot['application_status'],
      notes: pivot['application_notes'],
      appliedAt: pivot['applied_at'],
      reviewedAt: pivot['reviewed_at'],
      reviewedBy: pivot['reviewed_by'],
      documents: _decodeList(pivot['documents']),
      formData: _decodeMap(pivot['form_data']),
    );
  }
}

// --- private parse helpers ---

List<T> _mapList<T>(dynamic value, T Function(Map<String, dynamic>) fromJson) {
  if (value is! List) return const [];
  return value
      .map((e) => fromJson(Map<String, dynamic>.from(e as Map)))
      .toList();
}

List<dynamic> _decodeList(dynamic value) {
  if (value is List) return value;
  if (value is String && value.isNotEmpty) {
    try {
      final decoded = jsonDecode(value);
      return decoded is List ? decoded : [decoded];
    } catch (_) {}
  }
  return const [];
}

Map<String, dynamic> _decodeMap(dynamic value) {
  if (value is Map) return Map<String, dynamic>.from(value);
  if (value is String && value.isNotEmpty) {
    try {
      final decoded = jsonDecode(value);
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (_) {}
  }
  return const {};
}

