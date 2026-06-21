import 'package:smart_kishan/shared/models/multilingual_field.dart';

/// A document the farmer must (or may) upload when applying — defined by the
/// admin per subsidy. Drives the upload slots on the apply form.
class RequiredDocument {
  const RequiredDocument({
    this.name,
    this.description,
    this.isRequired = true,
    this.maxFileSize = 5,
    this.acceptedFormats = const ['pdf', 'jpg', 'png'],
  });

  final MultilingualField? name;
  final MultilingualField? description;
  final bool isRequired;

  /// Max size in MB.
  final int maxFileSize;
  final List<String> acceptedFormats;

  factory RequiredDocument.fromJson(Map<String, dynamic> json) {
    return RequiredDocument(
      name: MultilingualField.fromJson(json['name']),
      description: MultilingualField.fromJson(json['description']),
      isRequired: json['is_required'] ?? true,
      maxFileSize: json['max_file_size'] ?? 5,
      acceptedFormats: json['accepted_formats'] is List
          ? List<String>.from(json['accepted_formats'])
          : const ['pdf', 'jpg', 'png'],
    );
  }
}

/// An admin-uploaded reference document attached to the subsidy itself
/// (guidelines, forms to read, etc.).
class SubsidyDocument {
  const SubsidyDocument({
    this.fileName,
    this.filePath,
    this.fileType,
    this.fileSize,
  });

  final String? fileName;
  final String? filePath;
  final String? fileType;
  final int? fileSize;

  bool get isPdf => fileType?.toLowerCase() == 'pdf';
  bool get isImage =>
      const ['jpg', 'jpeg', 'png', 'gif'].contains(fileType?.toLowerCase());

  factory SubsidyDocument.fromJson(Map<String, dynamic> json) {
    return SubsidyDocument(
      fileName: json['file_name'],
      filePath: json['file_path'],
      fileType: json['file_type'],
      fileSize: json['file_size'],
    );
  }
}
