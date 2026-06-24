/// The authoritative rating aggregate returned by the server after a write
/// (rate / delete). The client trusts these values instead of recomputing the
/// average locally, so the headline figure can never drift from the backend.
class RatingAggregate {
  const RatingAggregate({required this.average, required this.total});

  final double average;
  final int total;

  /// Parses `{ average_rating, total_ratings }` from a write response. Tolerant
  /// of both numeric and string encodings (Laravel's `decimal` cast serializes
  /// as a string, while computed accessors return numbers).
  factory RatingAggregate.fromJson(Map<String, dynamic> json) {
    return RatingAggregate(
      average: double.tryParse('${json['average_rating']}') ?? 0,
      total:
          int.tryParse('${json['total_ratings']}') ??
          (num.tryParse('${json['total_ratings']}')?.toInt() ?? 0),
    );
  }
}
