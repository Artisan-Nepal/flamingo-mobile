class VerifyOtpRequest {
  String otpCode;
  String otpToken;

  VerifyOtpRequest({
    required this.otpCode,
    required this.otpToken,
  });

  Map<String, dynamic> toJson() => {
        "otpCode": otpCode,
        "otpToken": otpToken,
      };
}
