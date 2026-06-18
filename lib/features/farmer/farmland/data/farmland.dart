import 'dart:convert';

import 'package:smart_kishan/features/farmer/farmland/data/recommended_crops.dart';
import 'package:smart_kishan/shared/models/user.dart';

/// A farmer's farmland: title/description/image + geo (lat/lng) + soil
/// properties (nitrogen, phosphate, potassium, pH, organicMatter) + climate
/// (temperature, humidity, rainfall). Soil values arrive as strings with units
/// from the API and are parsed to doubles.
class Farmland {
  const Farmland({
    this.id,
    this.image,
    this.title,
    this.description,
    this.nitrogen,
    this.phosphate,
    this.potassium,
    this.pH,
    this.organicMatter,
    this.temperature,
    this.humidity,
    this.rainfall,
    this.lat,
    this.lng,
    this.address,
    this.recommendedCrops,
    this.userId,
    this.date,
    this.user,
  });

  final int? id;
  final String? image;
  final String? title;
  final String? description;
  final double? nitrogen;
  final double? phosphate;
  final double? potassium;
  final double? pH;
  final double? organicMatter;
  final double? temperature;
  final double? humidity;
  final double? rainfall;
  final double? lat;
  final double? lng;
  final String? address;
  final RecommendedCrops? recommendedCrops;
  final int? userId;
  final String? date;
  final User? user;

  static double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }

  factory Farmland.fromJson(Map<String, dynamic> json) => Farmland(
    id: json['id'] as int?,
    image: json['image'] as String?,
    title: json['title'] as String?,
    description: json['description'] as String?,
    nitrogen: _toDouble(json['nitrogen']),
    phosphate: _toDouble(json['phosphate']),
    potassium: _toDouble(json['potassium']),
    organicMatter: _toDouble(json['organic_matter']),
    pH: _toDouble(json['pH']),
    temperature: _toDouble(json['temperature']),
    humidity: _toDouble(json['humidity']),
    rainfall: _toDouble(json['rainfall']),
    lat: _toDouble(json['lat']),
    lng: _toDouble(json['lng']),
    address: json['address'] as String?,
    recommendedCrops: json['recommended_crops'] != null
        ? RecommendedCrops.fromJson(
            json['recommended_crops'] is String
                ? jsonDecode(json['recommended_crops']) as Map<String, dynamic>
                : json['recommended_crops'] as Map<String, dynamic>,
          )
        : null,

    userId: json['user_id'] as int?,
    date: json['created_at'] as String?,
    user: json['user'] != null
        ? User.fromJson(json['user'] as Map<String, dynamic>)
        : null,
  );

  /// Fields for the multipart form (image is sent separately as a file).
  Map<String, dynamic> toFormData() => {
    'title': title,
    'description': description,
    'lat': lat,
    'lng': lng,
    'address': address,
    'nitrogen': nitrogen,
    'phosphate': phosphate,
    'potassium': potassium,
    'pH': pH,
    'organic_matter': organicMatter,
    'temperature': temperature,
    'humidity': humidity,
    'rainfall': rainfall,
  };

  Farmland copyWith({String? image}) => Farmland(
    id: id,
    image: image ?? this.image,
    title: title,
    description: description,
    nitrogen: nitrogen,
    phosphate: phosphate,
    potassium: potassium,
    pH: pH,
    organicMatter: organicMatter,
    temperature: temperature,
    humidity: humidity,
    rainfall: rainfall,
    lat: lat,
    lng: lng,
    address: address,
    userId: userId,
    date: date,
    user: user,
  );
}
