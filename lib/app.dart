import 'package:flutter/material.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/feature.dart';
import 'package:flamingo/navigation/navigation.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => locator<ThemeService>()),
      ],
      builder: (ctx, child) {
        final themeService = Provider.of<ThemeService>(ctx);
        final navigationService = locator<NavigationService>();

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: Strings.appName,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeService.themeMode,
          initialRoute: navigationService.initialRoute,
          routes: navigationRoutes,
        );
      },
    );
  }
}
