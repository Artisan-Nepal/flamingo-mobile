class KhaltiInitiateRequest {
  final String billingAddressId;
  final String shippingAddressId;
  final String paymentMethodCode;
  final String shippingMethodId;
  final String? couponCode;

  KhaltiInitiateRequest({
    required this.billingAddressId,
    required this.shippingAddressId,
    required this.paymentMethodCode,
    required this.shippingMethodId,
    this.couponCode,
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
    return json;
  }
}
