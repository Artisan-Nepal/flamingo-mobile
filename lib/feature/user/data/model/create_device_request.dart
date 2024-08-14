class CreateDeviceRequest {
  String deviceId;
  String? notificationToken;

  CreateDeviceRequest({
    required this.deviceId,
    this.notificationToken,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {};
    jsonMap['deviceId'] = deviceId;
    if (notificationToken != null)
      jsonMap['notificationToken'] = notificationToken;

    return jsonMap;
  }
}
