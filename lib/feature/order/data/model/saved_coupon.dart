// A coupon the customer redeemed (saved to their wallet). Shown as a tappable
// suggestion chip at checkout, and listed in the Coupons wallet under Profile.
class SavedCoupon {
  final String couponId;
  final String code;
  final String label; // e.g. "10% off" / "Rs 200 off"
  // Wallet display: when the coupon expires, and how many more times this
  // customer may still redeem it (null = no per-user cap / unlimited).
  final DateTime? validUntil;
  final int? perUserUsageLimit;
  final int? remainingRedemptions;

  SavedCoupon({
    required this.couponId,
    required this.code,
    required this.label,
    this.validUntil,
    this.perUserUsageLimit,
    this.remainingRedemptions,
  });

  factory SavedCoupon.fromJson(Map<String, dynamic> json) => SavedCoupon(
        couponId: json['couponId'],
        code: json['code'],
        label: json['label'] ?? '',
        validUntil: json['validUntil'] == null
            ? null
            : DateTime.tryParse(json['validUntil'].toString()),
        perUserUsageLimit: json['perUserUsageLimit'],
        remainingRedemptions: json['remainingRedemptions'],
      );

  static List<SavedCoupon> fromJsonList(dynamic json) =>
      List<SavedCoupon>.from(json.map((data) => SavedCoupon.fromJson(data)));
}
