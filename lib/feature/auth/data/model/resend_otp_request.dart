class ResendOtpRequest {
  String otpToken;

  ResendOtpRequest({
    required this.otpToken,
  });

  Map<String, dynamic> toJson() => {
        "otpToken": otpToken,
      };
}
