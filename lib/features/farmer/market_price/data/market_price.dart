import 'package:smart_kishan/shared/models/multilingual_field.dart';

/// One market (e.g. Kalimati, Attariya) with its commodity prices, served by
/// our backend (which aggregates the external sources). Multilingual names.
///
/// [stale] is true when the backend couldn't get fresh data and is serving
/// the last known good price list from a previous date. The [date] field
/// will reflect that previous date so the UI can show it to the user.
class Market {
  const Market({
    required this.key,
    this.name,
    this.date,
    this.commodities = const [],
    this.stale = false,
  });

  final String key;
  final MultilingualField? name;
  final String? date; // last-updated date from the data source (raw)
  final List<CommodityPrice> commodities;
  final bool stale; // true = served from history cache, not today's data

  factory Market.fromJson(Map<String, dynamic> json) {
    final list = json['commodities'];
    return Market(
      key: (json['key'] ?? '').toString(),
      name: MultilingualField.fromJson(json['name']),
      date: json['date'] as String?,
      commodities: list is List
          ? list
                .whereType<Map<String, dynamic>>()
                .map(CommodityPrice.fromJson)
                .toList()
          : const [],
      stale: json['stale'] == true,
    );
  }
}

/// A single commodity's min/max/avg price in a market.
class CommodityPrice {
  const CommodityPrice({this.name, this.unit, this.min, this.max, this.avg});

  final MultilingualField? name;
  final MultilingualField? unit;
  final String? min;
  final String? max;
  final String? avg;

  factory CommodityPrice.fromJson(Map<String, dynamic> json) => CommodityPrice(
    name: MultilingualField.fromJson(json['name']),
    unit: MultilingualField.fromJson(json['unit']),
    min: json['min']?.toString(),
    max: json['max']?.toString(),
    avg: json['avg']?.toString(),
  );
}
