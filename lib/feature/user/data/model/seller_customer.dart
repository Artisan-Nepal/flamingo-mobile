class SellerCustomer {
  final String id;
  final String? mobileNumber;
  final String userId;
  final DateTime createdAt;
  final String? displayImageUrl;
  final String? sellerId;

  SellerCustomer(
      {required this.id,
      required this.mobileNumber,
      required this.userId,
      required this.createdAt,
      this.displayImageUrl,
      this.sellerId});

  factory SellerCustomer.fromJson(Map<String, dynamic> json) => SellerCustomer(
        id: json["id"],
        mobileNumber: json["mobileNumber"],
        userId: json["userId"],
        createdAt: DateTime.parse(json["createdAt"]),
        displayImageUrl: json['displayImageUrl'],
        sellerId: json['sellerId'],
      );
}
