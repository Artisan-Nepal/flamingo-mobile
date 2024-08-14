class UpdateDeviceRequest {
  String deviceId;
  String? notificationToken;

  UpdateDeviceRequest({
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
