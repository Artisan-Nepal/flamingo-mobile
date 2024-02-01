class VendorLikeResponse {
  final int count;

  VendorLikeResponse({
    required this.count,
  });

  factory VendorLikeResponse.fromJson(Map<String, dynamic> json) {
    return VendorLikeResponse(
      count: json['count'],
    );
  }
}
