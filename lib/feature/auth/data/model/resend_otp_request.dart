class ResendOtpRequest {
  String otpToken;

  ResendOtpRequest(
    this.otpToken,
  );

  Map<String, dynamic> toJson() => {
        "otpToken": otpToken,
      };
}
