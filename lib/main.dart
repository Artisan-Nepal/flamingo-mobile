import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flamingo/app.dart';
import 'package:flamingo/feature/theme/theme_service.dart';
import 'package:flamingo/navigation/navigation_service.dart';
import 'di/service_locator.dart' as di;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  final fcmToken = await FirebaseMessaging.instance.getToken();
  log("FCMToken $fcmToken");

  await di.setUpServiceLocator();
  await initApp();

  runApp(const App());
}

Future<void> initApp() async {
  await Future.wait([
    di.locator<NavigationService>().getInitialRoute(),
    di.locator<ThemeService>().initializeTheme(),
  ]);
}
