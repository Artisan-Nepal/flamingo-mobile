class CreateReviewRequest {
  final String productId;
  final int rating;
  final String? title;
  final String? comment;

  CreateReviewRequest({
    required this.productId,
    required this.rating,
    this.title,
    this.comment,
  });

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'rating': rating,
        if (title != null && title!.isNotEmpty) 'title': title,
        if (comment != null && comment!.isNotEmpty) 'comment': comment,
      };
}
