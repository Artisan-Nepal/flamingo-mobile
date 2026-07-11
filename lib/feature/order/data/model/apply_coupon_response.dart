class ApplyCouponResponse {
  final String couponId;
  final String code;
  final String discountType;
  final int subtotal;
  final int discountAmount;

  ApplyCouponResponse({
    required this.couponId,
    required this.code,
    required this.discountType,
    required this.subtotal,
    required this.discountAmount,
  });

  factory ApplyCouponResponse.fromJson(Map<String, dynamic> json) {
    return ApplyCouponResponse(
      couponId: json['couponId'],
      code: json['code'],
      discountType: json['discountType'],
      subtotal: json['subtotal'],
      discountAmount: json['discountAmount'],
    );
  }
}
