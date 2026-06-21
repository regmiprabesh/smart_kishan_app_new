/// A single farmer's rating + optional review of a subsidy, shown in the
/// detail screen's reviews list. Mirrors the service-center rating shape.
class SubsidyRating {
  const SubsidyRating({
    this.id,
    this.userName,
    this.rating = 0,
    this.review,
    this.createdAt,
  });

  final int? id;
  final String? userName;
  final int rating;
  final String? review;
  final String? createdAt;

  factory SubsidyRating.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    return SubsidyRating(
      id: json['id'],
      userName: json['user_name'] ??
          (user is Map ? user['name'] as String? : null),
      rating: int.tryParse('${json['rating'] ?? 0}') ?? 0,
      review: json['review'],
      createdAt: json['created_at'],
    );
  }
}
