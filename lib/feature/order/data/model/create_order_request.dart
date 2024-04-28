class CreateOrderRequest {
  final String billingAddressId;
  final String shippingAddressId;
  final String paymentMethodCode;
  final String shippingMethodId;
  final String? onlinePaymentToken;
  final String? checkoutId;

  CreateOrderRequest({
    required this.billingAddressId,
    required this.shippingAddressId,
    required this.paymentMethodCode,
    required this.shippingMethodId,
    this.onlinePaymentToken,
    this.checkoutId,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'billingAddressId': billingAddressId,
      'shippingAddressId': shippingAddressId,
      'paymentMethodCode': paymentMethodCode,
      'shippingMethodId': shippingMethodId,
    };
    if (onlinePaymentToken != null) {
      json['onlinePaymentToken'] = onlinePaymentToken!;
    }
    if (checkoutId != null) {
      json['checkoutId'] = checkoutId!;
    }

    return json;
  }
}
