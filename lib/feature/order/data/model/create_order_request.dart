class CreateOrderRequest {
  final String billingAddressId;
  final String shippingAddressId;
  final String paymentMethodCode;
  final String shippingMethodId;
  final String? couponCode;
  // "Buy Now" express checkout: order only these cart lines (leaving the rest of
  // the bag untouched). Null = check out the whole cart.
  final List<String>? productVariantIds;

  CreateOrderRequest({
    required this.billingAddressId,
    required this.shippingAddressId,
    required this.paymentMethodCode,
    required this.shippingMethodId,
    this.couponCode,
    this.productVariantIds,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'billingAddressId': billingAddressId,
      'shippingAddressId': shippingAddressId,
      'paymentMethodCode': paymentMethodCode,
      'shippingMethodId': shippingMethodId,
    };
    if (couponCode != null) {
      json['couponCode'] = couponCode;
    }
    if (productVariantIds != null && productVariantIds!.isNotEmpty) {
      json['productVariantIds'] = productVariantIds;
    }
    return json;
  }
}
