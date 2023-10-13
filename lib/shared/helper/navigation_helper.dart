import 'package:flutter/material.dart';

class NavigationHelper {
  static Future push(BuildContext context, Widget screen) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }

  static Future pushReplacement(BuildContext context, Widget screen) async {
    return await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }

  static void pop(BuildContext context) {
    Navigator.pop(context);
  }
}
