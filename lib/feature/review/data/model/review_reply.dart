// The seller's public reply to a review (VENDOR_REVIEW_REPLIES_PLAN.md).
// storeName is the display attribution ("Response from {storeName}") -
// derived server-side at read time, never a stored/stale value here.
class ReviewReply {
  final String id;
  final String body;
  final String storeName;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReviewReply({
    required this.id,
    required this.body,
    required this.storeName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReviewReply.fromJson(Map<String, dynamic> json) => ReviewReply(
        id: json['id'],
        body: json['body'],
        storeName: json['storeName'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );
}
