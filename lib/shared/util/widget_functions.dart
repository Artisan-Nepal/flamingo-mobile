import 'package:flutter/material.dart';

Widget addVerticalSpace(double height) {
  return SizedBox(height: height);
}

Widget addBottomSpace(double height) {
  return Padding(
    padding: EdgeInsets.only(bottom: height),
  );
}

Widget addTopSpace(double height) {
  return Padding(
    padding: EdgeInsets.only(top: height),
  );
}

Widget addHorizontalSpace(double width) {
  return SizedBox(width: width);
}
