
import 'package:smart_kishan/shared/models/location.dart';
import 'package:smart_kishan/shared/models/multilingual_field.dart';

/// A category of service center (e.g. Agriculture Office, Vet, Cooperative).
/// `color` is a hex string from the backend (defaults to the app green); the
/// map markers and detail header tint themselves with it.
class ServiceCenterType {
  const ServiceCenterType({
    required this.id,
    this.name,
    this.icon,
    this.color,
    this.description,
    this.isActive = true,
    this.serviceCentersCount,
  });

  final int id;
  final MultilingualField? name;
  final String? icon; // backend icon key (mapped to an IconData)
  final String? color; // hex, e.g. "#4CAF50"
  final MultilingualField? description;
  final bool isActive;
  final int? serviceCentersCount;

  factory ServiceCenterType.fromJson(Map<String, dynamic> json) {
    return ServiceCenterType(
      id: json['id'] as int,
      // name / description: use _ml() so both Map and JSON-string shapes work.
      name: MultilingualField.fromJson(json['name']),
      icon: json['icon'] as String?,
      color: json['color'] as String? ?? '#4CAF50',
      description: MultilingualField.fromJson(json['description']),
      isActive: json['is_active'] as bool? ?? true,
      serviceCentersCount: json['service_centers_count'] as int?,
    );
  }
}

class ServiceCenter {
  const ServiceCenter({
    required this.id,
    required this.serviceCenterTypeId,
    this.type,
    this.name,
    this.address,
    required this.latitude,
    required this.longitude,
    this.province,
    this.district,
    this.municipality,
    this.wardNo,
    this.phone,
    this.email,
    this.website,
    this.operatingHours,
    this.services,
    this.description,
    this.contactPerson,
    this.contactPersonDesignation,
    this.images,
    this.isActive = true,
    this.isFeatured = false,
    this.distance,
    this.averageRating,
    this.totalRatings,
    this.userRating,
    this.ratings,
  });

  final int id;
  final int serviceCenterTypeId;
  final ServiceCenterType? type;
  final MultilingualField? name;
  final MultilingualField? address;
  final double latitude;
  final double longitude;
  final Province? province;
  final District? district;
  final Municipality? municipality;
  final int? wardNo;
  final String? phone;
  final String? email;
  final String? website;

  /// Raw operating-hours map from backend (e.g. {"sun": "10:00 - 17:00", …}).
  final List<OperatingHourEntry>? operatingHours;
  final List<MultilingualField?>? services;
  final MultilingualField? description;

  // contact_person and contact_person_designation are translatable on the
  // backend ($casts = ['contact_person' => 'array', …]), so parse them with
  // _ml() instead of casting directly to String.
  final MultilingualField? contactPerson;
  final MultilingualField? contactPersonDesignation;

  final List<String>? images; // full URLs (backend accessor)
  final bool isActive;
  final bool isFeatured;

  /// Distance in km from the user (server-computed when lat/lng supplied).
  final double? distance;
  final double? averageRating;
  final int? totalRatings;

  /// The signed-in user's own rating, if any.
  final ServiceCenterRating? userRating;

  /// Recent ratings (only populated on the detail endpoint).
  final List<ServiceCenterRating>? ratings;

  factory ServiceCenter.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic v) => v == null ? 0.0 : double.parse(v.toString());
    double? toDoubleN(dynamic v) =>
        v == null ? null : double.parse(v.toString());

    return ServiceCenter(
      id: json['id'] as int? ?? 0,
      serviceCenterTypeId: json['service_center_type_id'] as int? ?? 0,
      type: json['type'] != null && json['type'] is Map
          ? ServiceCenterType.fromJson(
              Map<String, dynamic>.from(json['type'] as Map),
            )
          : null,
      // All translatable string columns: use _ml() for both Map + String shapes.
      name: MultilingualField.fromJson(json['name']),
      address: MultilingualField.fromJson(json['address']),
      latitude: toDouble(json['latitude']),
      longitude: toDouble(json['longitude']),
      province: json['province'] != null && json['province'] is Map
          ? Province.fromJson(
              Map<String, dynamic>.from(json['province'] as Map),
            )
          : null,
      district: json['district'] != null && json['district'] is Map
          ? District.fromJson(
              Map<String, dynamic>.from(json['district'] as Map),
            )
          : null,
      municipality: json['municipality'] != null && json['municipality'] is Map
          ? Municipality.fromJson(
              Map<String, dynamic>.from(json['municipality'] as Map),
            )
          : null,
      wardNo: json['ward_no'] as int?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      website: json['website'] as String?,
      operatingHours:
          json['operating_hours'] != null && json['operating_hours'] is List
          ? (json['operating_hours'] as List)
                .map(
                  (e) => OperatingHourEntry.fromJson(
                    Map<String, dynamic>.from(e as Map),
                  ),
                )
                .toList()
          : null,
      services: json['services'] != null && json['services'] is List
          ? (json['services'] as List)
                .map((e) => MultilingualField.fromJson(e))
                .whereType<MultilingualField>()
                .toList()
          : null,
      description: MultilingualField.fromJson(json['description']),
      // contact_person / contact_person_designation are now MultilingualField.
      contactPerson: MultilingualField.fromJson(json['contact_person']),
      contactPersonDesignation: MultilingualField.fromJson(
        json['contact_person_designation'],
      ),
      images: json['images'] != null && json['images'] is List
          ? List<String>.from(json['images'] as List)
          : null,
      isActive: json['is_active'] as bool? ?? true,
      isFeatured: json['is_featured'] as bool? ?? false,
      distance: toDoubleN(json['distance']),
      averageRating: toDoubleN(json['average_rating']),
      totalRatings: json['total_ratings'] as int?,
      userRating: json['user_rating'] != null && json['user_rating'] is Map
          ? ServiceCenterRating.fromJson(
              Map<String, dynamic>.from(json['user_rating'] as Map),
            )
          : null,
      ratings: json['ratings'] != null && json['ratings'] is List
          ? (json['ratings'] as List)
                .map(
                  (r) => ServiceCenterRating.fromJson(
                    Map<String, dynamic>.from(r),
                  ),
                )
                .toList()
          : null,
    );
  }

  bool get hasRatings => (averageRating ?? 0) > 0 && (totalRatings ?? 0) > 0;

  /// Returns a copy with a replaced user rating + recomputed aggregate, so the
  /// cubit can update local state after rate/delete without a refetch.
  ServiceCenter copyWith({
    ServiceCenterRating? userRating,
    bool clearUserRating = false,
    double? averageRating,
    int? totalRatings,
    List<ServiceCenterRating>? ratings,
  }) {
    return ServiceCenter(
      id: id,
      serviceCenterTypeId: serviceCenterTypeId,
      type: type,
      name: name,
      address: address,
      latitude: latitude,
      longitude: longitude,
      province: province,
      district: district,
      municipality: municipality,
      wardNo: wardNo,
      phone: phone,
      email: email,
      website: website,
      operatingHours: operatingHours,
      services: services,
      description: description,
      contactPerson: contactPerson,
      contactPersonDesignation: contactPersonDesignation,
      images: images,
      isActive: isActive,
      isFeatured: isFeatured,
      distance: distance,
      averageRating: averageRating ?? this.averageRating,
      totalRatings: totalRatings ?? this.totalRatings,
      userRating: clearUserRating ? null : (userRating ?? this.userRating),
      ratings: ratings ?? this.ratings,
    );
  }
}

class ServiceCenterRating {
  const ServiceCenterRating({
    required this.id,
    required this.serviceCenterId,
    required this.userId,
    required this.rating,
    this.review,
    this.createdAt,
    this.userName,
  });

  final int id;
  final int serviceCenterId;
  final int userId;
  final int rating;
  final String? review;
  final DateTime? createdAt;
  final String? userName;

  factory ServiceCenterRating.fromJson(Map<String, dynamic> json) {
    return ServiceCenterRating(
      id: json['id'] as int? ?? 0,
      serviceCenterId: json['service_center_id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      rating: json['rating'] as int? ?? 0,
      review: json['review'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      userName: json['user'] != null && json['user'] is Map
          ? (json['user']['name'] as String?)
          : null,
    );
  }
}

class OperatingHourEntry {
  const OperatingHourEntry({
    required this.day,
    required this.label,
    required this.closed,
    required this.hours,
  });

  final String day;
  final MultilingualField label;
  final bool closed;
  final MultilingualField hours;

  factory OperatingHourEntry.fromJson(Map<String, dynamic> json) {
    return OperatingHourEntry(
      day: json['day'] as String? ?? '',
      label:
          MultilingualField.fromJson(json['label']) ??
          MultilingualField(en: 'aa', ne: 'bb'),
      closed: json['closed'] as bool? ?? false,
      hours:
          MultilingualField.fromJson(json['hours']) ??
          MultilingualField(en: 'aaa', ne: 'bbb'),
    );
  }
}
