class InitiateOnlineCheckoutRequest {
  final String paymentMethodCode;
  final String shippingMethodId;

  InitiateOnlineCheckoutRequest({
    required this.paymentMethodCode,
    required this.shippingMethodId,
  });

  Map<String, dynamic> toJson() {
    return {
      'paymentMethodCode': paymentMethodCode,
      'shippingMethodId': shippingMethodId,
    };
  }
}
