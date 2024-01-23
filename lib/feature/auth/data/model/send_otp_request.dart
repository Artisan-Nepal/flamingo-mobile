class SendOtpRequest {
  String email;

  SendOtpRequest({
    required this.email,
  });

  Map<String, dynamic> toJson() => {
        "email": email,
      };
}
