import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenHeight;
  static late double screenWidth;
  static late Orientation orientation;
  static late double statusBarHeight;
  static late double appBarHeight;
  static late double deviceRatio;

  static double get screenHeightWithoutStatusBar =>
      screenHeight - statusBarHeight;
  static double get screenHeightWithoutStatusAndAppBar =>
      screenHeight - statusBarHeight - appBarHeight;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenHeight = _mediaQueryData.size.height;
    screenWidth = _mediaQueryData.size.width;
    orientation = _mediaQueryData.orientation;
    statusBarHeight = _mediaQueryData.padding.top;
    appBarHeight = AppBar().preferredSize.height;
    deviceRatio = _mediaQueryData.size.aspectRatio;
  }
}
