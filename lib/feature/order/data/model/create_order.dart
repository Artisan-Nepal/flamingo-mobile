class CreateOrderRequest {
  final String billingAddressId;
  final String shippingAddressId;
  final String paymentMethodId;
  final String shippingMethodId;

  CreateOrderRequest({
    required this.billingAddressId,
    required this.shippingAddressId,
    required this.paymentMethodId,
    required this.shippingMethodId,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'billingAddressId': billingAddressId,
      'shippingAddressId': shippingAddressId,
      'paymentMethodId': paymentMethodId,
      'shipping_method_id': shippingMethodId,
    };
  }
}
