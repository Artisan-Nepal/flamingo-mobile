/// Result of tapping a promo banner to save its coupon. Lets the UI give honest
/// feedback instead of a blanket "saved" toast on every repeat tap.
enum CouponRedeemOutcome {
  /// Freshly saved to the wallet.
  saved,

  /// Already in the wallet (redeemed before), still unused.
  alreadyRedeemed,

  /// The customer has already used this coupon (or it's globally maxed out).
  alreadyUsed,

  /// Network/validation error - a genuine failure.
  failed;

  factory CouponRedeemOutcome.fromData(dynamic data) {
    if (data is Map) {
      if (data['alreadyUsed'] == true) return CouponRedeemOutcome.alreadyUsed;
      if (data['alreadyRedeemed'] == true) {
        return CouponRedeemOutcome.alreadyRedeemed;
      }
    }
    return CouponRedeemOutcome.saved;
  }
}
