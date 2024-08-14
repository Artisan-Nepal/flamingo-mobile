import 'dart:io';
import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoHelper {
  static final _deviceInfo = DeviceInfoPlugin();
  static const _androidIdPlugin = AndroidId();
  static Future<DeviceInfoModel> getDeviceInfo() async {
    {
      late DeviceInfoModel deviceInfoModel;
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
        deviceInfoModel = DeviceInfoModel(
          deviceId: await _androidIdPlugin.getId() ?? "",
          deviceModel: androidInfo.model,
          deviceName: androidInfo.device,
        );
      } else {
        IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
        deviceInfoModel = DeviceInfoModel(
          deviceId: iosInfo.identifierForVendor ?? "",
          deviceModel: iosInfo.model,
          deviceName: iosInfo.name,
        );
      }
      return deviceInfoModel;
    }
  }
}

class DeviceInfoModel {
  String deviceId;
  String deviceName;
  String deviceModel;

  DeviceInfoModel({
    required this.deviceId,
    required this.deviceModel,
    required this.deviceName,
  });
}
