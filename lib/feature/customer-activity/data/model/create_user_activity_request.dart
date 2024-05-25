class CreateUserActivityRequest {
  final String userId;
  final String? sellerId;
  final String? productId;
  final String activityType;

  CreateUserActivityRequest({
    required this.userId,
    required this.sellerId,
    required this.productId,
    required this.activityType,
  });

  Map<String, dynamic> toJson() {
    final json = {
      "userId": userId,
      "activityType": activityType,
    };

    if (sellerId != null) {
      json['sellerId'] = sellerId!;
    }
    if (productId != null) {
      json['productId'] = productId!;
    }

    return json;
  }
}
