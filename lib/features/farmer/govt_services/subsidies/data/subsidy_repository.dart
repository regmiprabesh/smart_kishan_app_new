import 'package:smart_kishan/core/constants/api_endpoints.dart';
import 'package:smart_kishan/core/network/api_client.dart';

import 'subsidy.dart';
import 'subsidy_rating.dart';

/// Remote data source for the subsidies feature (list, applications, ratings,
/// withdraw, apply).
class SubsidyRepository {
  SubsidyRepository({required this.api});

  final ApiClient api;

  /// GET /farmer/subsidies — available subsidies for the farmer's location.
  Future<List<Subsidy>> fetchSubsidies() async {
    final res = await api.get(ApiEndpoints.subsidies);
    return _subsidyList(res.data);
  }

  /// GET /farmer/subsidy-applications — subsidies the farmer applied to
  /// (each carries pivot `application` data).
  Future<List<Subsidy>> fetchMyApplications() async {
    final res = await api.get(ApiEndpoints.subsidyApplications);
    return _subsidyList(res.data);
  }

  /// DELETE /farmer/subsidies/{id}/withdraw
  Future<void> withdrawApplication(int subsidyId) =>
      api.delete(ApiEndpoints.subsidyWithdraw(subsidyId));

  /// POST /farmer/subsidies/{id}/rate
  Future<void> rateSubsidy({
    required int subsidyId,
    required int rating,
    String? review,
  }) =>
      api.post(
        ApiEndpoints.subsidyRate(subsidyId),
        body: {'rating': rating, 'review': review},
      );

  /// GET /farmer/subsidies/{id}/ratings
  Future<List<SubsidyRating>> fetchRatings(int subsidyId) async {
    final res = await api.get(ApiEndpoints.subsidyRatings(subsidyId));
    final list = (res.data as List?) ?? const [];
    return list
        .map((e) => SubsidyRating.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  /// GET /farmer/subsidies/{id}/my-rating — null when the farmer hasn't rated.
  Future<SubsidyRating?> fetchMyRating(int subsidyId) async {
    final res = await api.get(ApiEndpoints.subsidyMyRating(subsidyId));
    final data = res.data;
    if (data is Map && data.isNotEmpty) {
      return SubsidyRating.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  /// DELETE /farmer/subsidies/{id}/my-rating
  Future<void> deleteRating(int subsidyId) =>
      api.delete(ApiEndpoints.subsidyMyRating(subsidyId));

  /// POST /farmer/subsidies/{id}/apply (multipart).
  ///
  /// Sends `application_notes`, a `form_data[key]` entry per dynamic field, and
  /// an indexed `documents[]` array (each with a file + its document_type).
  Future<void> apply({
    required int subsidyId,
    required String notes,
    required Map<String, String> formData,
    required List<ApplyDocument> documents,
  }) {
    final fields = <String, String>{'application_notes': notes};
    formData.forEach((k, v) => fields['form_data[$k]'] = v);
    final files = <String, String>{};
    for (var i = 0; i < documents.length; i++) {
      fields['documents[$i][document_type]'] = documents[i].documentType;
      files['documents[$i][file]'] = documents[i].filePath;
    }
    return api.postMultipart(
      ApiEndpoints.subsidyApply(subsidyId),
      fields: fields,
      files: files,
    );
  }

  List<Subsidy> _subsidyList(dynamic data) {
    final list = (data as List?) ?? const [];
    return list
        .map((e) => Subsidy.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }
}

/// One uploaded document for an application: which required-document slot it
/// fills ([documentType]) and the local [filePath] to upload.
class ApplyDocument {
  const ApplyDocument({required this.documentType, required this.filePath});
  final String documentType;
  final String filePath;
}
