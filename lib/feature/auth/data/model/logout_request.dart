class LogoutRequest {
  String deviceId;

  LogoutRequest({
    required this.deviceId,
  });

  Map<String, dynamic> toJson() => {
        "deviceId": deviceId,
      };
}
