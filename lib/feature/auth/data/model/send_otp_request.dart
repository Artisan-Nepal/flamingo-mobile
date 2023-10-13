class SendOtpRequest {
  String mobileNumber;

  SendOtpRequest({
    required this.mobileNumber,
  });

  Map<String, dynamic> toJson() => {
        "mobileNumber": mobileNumber,
      };
}
