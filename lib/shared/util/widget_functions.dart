import 'package:flutter/material.dart';

import '../shared.dart';

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

OutlineInputBorder generateBorder(Color borderColor,
    {bool isFocused = false, double radius = Dimens.radiusSmall}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(radius),
    borderSide: BorderSide(width: isFocused ? 1.3 : 1.2, color: borderColor),
  );
}
