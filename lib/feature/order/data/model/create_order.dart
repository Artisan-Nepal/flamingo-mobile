class CreateOrderRequest {
  final String billingAddressId;
  final String shippingAddressId;
  final String paymentMethodCode;
  final String shippingMethodId;

  CreateOrderRequest({
    required this.billingAddressId,
    required this.shippingAddressId,
    required this.paymentMethodCode,
    required this.shippingMethodId,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'billingAddressId': billingAddressId,
      'shippingAddressId': shippingAddressId,
      'paymentMethodCode': paymentMethodCode,
      'shippingMethodId': shippingMethodId,
    };
  }
}
