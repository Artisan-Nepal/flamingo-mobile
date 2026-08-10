enum ReviewSort { recent, highest, lowest }

extension ReviewSortQueryValue on ReviewSort {
  String get queryValue {
    switch (this) {
      case ReviewSort.recent:
        return 'recent';
      case ReviewSort.highest:
        return 'highest';
      case ReviewSort.lowest:
        return 'lowest';
    }
  }

  String get label {
    switch (this) {
      case ReviewSort.recent:
        return 'Most recent';
      case ReviewSort.highest:
        return 'Highest rated';
      case ReviewSort.lowest:
        return 'Lowest rated';
    }
  }
}

// Sort + star filter for GET /products/:id/reviews. `star` narrows to
// reviews with exactly that rating (1-5); null means all ratings.
class ReviewFilterParams {
  final ReviewSort sort;
  final int? star;

  const ReviewFilterParams({
    this.sort = ReviewSort.recent,
    this.star,
  });

  ReviewFilterParams copyWith({
    ReviewSort? sort,
    int? star,
    bool clearStar = false,
  }) {
    return ReviewFilterParams(
      sort: sort ?? this.sort,
      star: clearStar ? null : (star ?? this.star),
    );
  }

  Map<String, String> toQueryParams() => {
        'sort': sort.queryValue,
        if (star != null) 'star': star.toString(),
      };
}
