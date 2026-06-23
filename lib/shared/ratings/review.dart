/// A single rating + optional written review, feature-agnostic. Service
/// centers, subsidies, and (later) products map their own rating models onto
/// this so the whole ratings UI — section, reviews page, rate page — can be
/// shared.
class Review {
  const Review({
    this.id,
    this.userName,
    this.rating = 0,
    this.text,
    this.createdAt,
    this.tags = const [],
  });

  final int? id;
  final String? userName;
  final int rating;
  final String? text;
  final DateTime? createdAt;
  final List<String> tags;
}
