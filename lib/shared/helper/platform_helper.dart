import 'dart:io';

import 'package:flutter/foundation.dart';

class PlatformHelper {
  static TargetPlatform get platform {
    if (Platform.isIOS) return TargetPlatform.iOS;
    return TargetPlatform.android;
  }
}
