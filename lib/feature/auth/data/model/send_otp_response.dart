class SendOtpResponse {
  String otpToken;

  SendOtpResponse({
    required this.otpToken,
  });

  factory SendOtpResponse.fromJson(Map<String, dynamic> json) =>
      SendOtpResponse(
        otpToken: json["otpToken"],
      );
}
