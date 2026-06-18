/// Parsed response from the NARC soil API
class SoilData {
  const SoilData({
    this.ph,
    this.organicMatter,
    this.totalNitrogen,
    this.potassium,
    this.p2o5,
  });

  final double? ph;
  final double? organicMatter;
  final double? totalNitrogen;
  final double? potassium;
  final double? p2o5;

  /// Pulls the first numeric token out of a unit-tagged string.
  static double? _num(dynamic input) {
    if (input == null) return null;
    final match = RegExp(r'[0-9.]+').firstMatch(input.toString());
    return match == null ? null : double.tryParse(match.group(0)!);
  }

  factory SoilData.fromJson(Map<String, dynamic> json) => SoilData(
    ph: _num(json['ph']),
    organicMatter: _num(json['organic_matter']),
    totalNitrogen: _num(json['total_nitrogen']),
    potassium: _num(json['potassium']),
    p2o5: _num(json['p2o5']),
  );
}
