import 'package:flutter/material.dart';

class NavigationHelper {
  static bool canPop(BuildContext context) {
    return Navigator.canPop(context);
  }

  static Future push(BuildContext context, Widget screen) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }

  static Future pushWithoutAnimation(
      BuildContext context, Widget screen) async {
    return await Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        pageBuilder: (context, animation, secondaryAnimation) => screen,
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

  static void pushAndReplaceAll(BuildContext context, Widget screen) async {
    await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => screen,
        ),
        (route) => false);
  }
}
