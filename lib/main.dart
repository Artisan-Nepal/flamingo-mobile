import 'package:flamingo/%20notification/notification.dart';
import 'package:flutter/material.dart';
import 'package:flamingo/app.dart';
import 'package:flamingo/feature/theme/theme_service.dart';
import 'package:flamingo/navigation/navigation_service.dart';
import 'di/service_locator.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Backstop for the image-cache growth that got the app jetsam-killed at iOS's
  // ~3GB per-process limit. The per-widget decode caps (see
  // CachedNetworkImageWidget) are the real fix; this bounds what the cache can
  // retain on top of that. Flutter's defaults are 1000 images / 100MB, and the
  // count limit is the one that hurts on image-heavy grids.
  PaintingBinding.instance.imageCache
    ..maximumSizeBytes = 80 << 20 // 80 MB
    ..maximumSize = 150; // decoded images retained

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
