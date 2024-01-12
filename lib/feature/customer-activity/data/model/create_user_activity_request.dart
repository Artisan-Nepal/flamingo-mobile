class CreateUserActivityRequest {
  final String userId;
  final String? vendorId;
  final String? productId;
  final String activityType;

  CreateUserActivityRequest({
    required this.userId,
    required this.vendorId,
    required this.productId,
    required this.activityType,
  });

  Map<String, dynamic> toJson() {
    final json = {
      "userId": userId,
      "activityType": activityType,
    };

    if (vendorId != null) {
      json['vendorId'] = vendorId!;
    }
    if (productId != null) {
      json['productId'] = productId!;
    }

    return json;
  }
}
