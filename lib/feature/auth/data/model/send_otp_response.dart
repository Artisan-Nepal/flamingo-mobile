class SendOtpResponse {
  String otpToken;
  int cooldown;

  SendOtpResponse({
    required this.otpToken,
    required this.cooldown,
  });

  factory SendOtpResponse.fromJson(Map<String, dynamic> json) =>
      SendOtpResponse(
        otpToken: json["otpToken"],
        cooldown: json["cooldown"],
      );
}
