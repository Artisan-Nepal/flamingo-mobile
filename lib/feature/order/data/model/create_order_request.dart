class CreateOrderRequest {
  final String billingAddressId;
  final String shippingAddressId;
  final String paymentMethodCode;
  final String shippingMethodId;
  final String? paymentToken;

  CreateOrderRequest({
    required this.billingAddressId,
    required this.shippingAddressId,
    required this.paymentMethodCode,
    required this.shippingMethodId,
    this.paymentToken,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'billingAddressId': billingAddressId,
      'shippingAddressId': shippingAddressId,
      'paymentMethodCode': paymentMethodCode,
      'shippingMethodId': shippingMethodId,
    };
    if (paymentToken != null) {
      json['paymentToken'] = paymentToken!;
    }

    return json;
  }
}
