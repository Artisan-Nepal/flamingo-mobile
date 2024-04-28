class InitiateOnlineCheckoutResponse {
  final String checkoutId;
  final String onlinePaymentToken;

  InitiateOnlineCheckoutResponse({
    required this.checkoutId,
    required this.onlinePaymentToken,
  });

  factory InitiateOnlineCheckoutResponse.fromJson(Map<String, dynamic> json) =>
      InitiateOnlineCheckoutResponse(
        checkoutId: json['checkoutId'],
        onlinePaymentToken: json['onlinePaymentToken'],
      );
}
