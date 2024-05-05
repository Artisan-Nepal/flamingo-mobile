import 'package:flamingo/%20notification/notification.dart';
import 'package:flutter/material.dart';
import 'package:flamingo/app.dart';
import 'package:flamingo/feature/theme/theme_service.dart';
import 'package:flamingo/navigation/navigation_service.dart';
import 'di/service_locator.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.setUpServiceLocator();
  await initApp();

  runApp(const App());
}

Future<void> initApp() async {
  await di.locator<NotificationService>().initialize();
  await di.locator<NotificationService>().setup();
  await Future.wait([
    di.locator<NavigationService>().getInitialRoute(),
    di.locator<ThemeService>().initializeTheme(),
  ]);
}
