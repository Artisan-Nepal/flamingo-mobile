import 'package:flamingo/feature/review/data/model/review_reply.dart';

class Review {
  final String id;
  final String productId;
  final int rating;
  final String? title;
  final String? comment;
  final String reviewerName;
  final String? reviewerAvatar;
  final bool isVerifiedPurchase;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ReviewReply? reply;

  Review({
    required this.id,
    required this.productId,
    required this.rating,
    required this.reviewerName,
    required this.isVerifiedPurchase,
    required this.createdAt,
    required this.updatedAt,
    this.title,
    this.comment,
    this.reviewerAvatar,
    this.reply,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json['id'],
        productId: json['productId'],
        rating: json['rating'],
        title: json['title'],
        comment: json['comment'],
        reviewerName: json['reviewerName'],
        reviewerAvatar: json['reviewerAvatar'],
        isVerifiedPurchase: json['isVerifiedPurchase'] ?? false,
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        reply: json['reply'] == null ? null : ReviewReply.fromJson(json['reply']),
      );

  static List<Review> fromJsonList(dynamic json) => List<Review>.from(
        json.map(
          (data) => Review.fromJson(data),
        ),
      );
}
