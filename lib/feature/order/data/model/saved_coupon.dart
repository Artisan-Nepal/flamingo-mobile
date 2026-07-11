// A coupon the customer redeemed (saved to their wallet), shown as a tappable
// suggestion chip at checkout. Tapping fills + applies the code.
class SavedCoupon {
  final String couponId;
  final String code;
  final String label; // e.g. "10% off" / "Rs 200 off"

  SavedCoupon({
    required this.couponId,
    required this.code,
    required this.label,
  });

  factory SavedCoupon.fromJson(Map<String, dynamic> json) => SavedCoupon(
        couponId: json['couponId'],
        code: json['code'],
        label: json['label'] ?? '',
      );

  static List<SavedCoupon> fromJsonList(dynamic json) =>
      List<SavedCoupon>.from(json.map((data) => SavedCoupon.fromJson(data)));
}
