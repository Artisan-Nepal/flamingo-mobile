class KhaltiInitiateResponse {
  final String pidx;
  final String paymentUrl;
  final String expiresAt;
  final String intentId;

  KhaltiInitiateResponse({
    required this.pidx,
    required this.paymentUrl,
    required this.expiresAt,
    required this.intentId,
  });

  factory KhaltiInitiateResponse.fromJson(Map<String, dynamic> json) {
    return KhaltiInitiateResponse(
      pidx: json['pidx'],
      paymentUrl: json['paymentUrl'],
      expiresAt: json['expiresAt'],
      intentId: json['intentId'],
    );
  }
}
