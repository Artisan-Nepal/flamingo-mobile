import 'package:flutter/material.dart';

class NavigationHelper {
  // Set as MaterialApp's navigatorKey in app.dart. Needed for navigation
  // triggered outside any screen's BuildContext - specifically, routing on a
  // notification tap, which can happen while the app is backgrounded or was
  // freshly launched from a terminated state (see NotificationService).
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static bool canPop(BuildContext context) {
    return Navigator.canPop(context);
  }

  // Context-free variants of push/pushAndReplaceAll for use from
  // NotificationService. Silently no-ops if the navigator isn't mounted yet
  // (e.g. a background-tap handler firing before the first frame).
  static Future<void> pushGlobal(Widget screen) async {
    final state = navigatorKey.currentState;
    if (state == null) return;
    await state.push(MaterialPageRoute(builder: (context) => screen));
  }

  static Future<void> pushAndReplaceAllGlobal(Widget screen) async {
    final state = navigatorKey.currentState;
    if (state == null) return;
    await state.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => screen),
      (route) => false,
    );
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

  static Future pushNamed(BuildContext context, String routeName) async {
    return await Navigator.pushNamed(context, routeName);
  }

  static Future pushReplacementNamed(
      BuildContext context, String routeName) async {
    return await Navigator.pushReplacementNamed(context, routeName);
  }

  static void pushNamedAndReplaceAll(
      BuildContext context, String routeName) async {
    await Navigator.pushNamedAndRemoveUntil(
        context, routeName, (route) => false);
  }

  static void popUntil(BuildContext context, int count) {
    Navigator.of(context).popUntil((route) => count-- <= 0);
  }
}
