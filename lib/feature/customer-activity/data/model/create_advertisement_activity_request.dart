class CreateAdvertisementActivityRequest {
  final String userId;
  final String advertisementId;
  final String? productId;
  final String activityType;

  CreateAdvertisementActivityRequest({
    required this.userId,
    required this.advertisementId,
    required this.productId,
    required this.activityType,
  });

  Map<String, dynamic> toJson() {
    final json = {
      "userId": userId,
      "activityType": activityType,
      "advertisementId": advertisementId,
    };

    if (productId != null) {
      json['productId'] = productId!;
    }

    return json;
  }
}
