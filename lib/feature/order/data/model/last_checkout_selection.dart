// The address/shipping-method ids the customer used on their last checkout,
// re-applied as defaults on the next one. Each is nullable: a first-ever
// checkout has none, and any one may have been deleted since (resolved against
// the live lists at apply time, so a stale id just falls back to unselected).
class LastCheckoutSelection {
  final String? shippingAddressId;
  final String? billingAddressId;
  final String? shippingMethodId;

  const LastCheckoutSelection({
    this.shippingAddressId,
    this.billingAddressId,
    this.shippingMethodId,
  });

  bool get isEmpty =>
      shippingAddressId == null &&
      billingAddressId == null &&
      shippingMethodId == null;
}
