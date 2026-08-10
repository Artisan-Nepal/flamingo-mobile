class ReviewSummary {
  final double averageRating;
  final int totalCount;
  // Star value (1-5) -> count of reviews with that rating.
  final Map<int, int> breakdown;

  ReviewSummary({
    required this.averageRating,
    required this.totalCount,
    required this.breakdown,
  });

  int countFor(int star) => breakdown[star] ?? 0;

  // Share of totalCount for a given star, used to size the distribution bar.
  double fractionFor(int star) =>
      totalCount == 0 ? 0 : countFor(star) / totalCount;

  factory ReviewSummary.empty() => ReviewSummary(
        averageRating: 0,
        totalCount: 0,
        breakdown: const {},
      );

  factory ReviewSummary.fromJson(Map<String, dynamic> json) {
    final rawBreakdown = json['breakdown'] as Map<String, dynamic>? ?? {};
    return ReviewSummary(
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      totalCount: json['totalCount'] ?? 0,
      breakdown: rawBreakdown.map(
        (key, value) => MapEntry(int.parse(key), value as int),
      ),
    );
  }
}
