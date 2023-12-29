import 'package:flamingo/feature/auth/auth_view_model.dart';
import 'package:flamingo/feature/customer-activity/customer_activity_view_model.dart';
import 'package:flamingo/feature/wishlist/wishlist_view_model.dart';
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
        ChangeNotifierProvider(create: (ctx) => locator<AuthViewModel>()),
        ChangeNotifierProvider(create: (ctx) => locator<WishlistViewModel>()),
        ChangeNotifierProvider(
            create: (ctx) => locator<CustomerActivityViewModel>()),
      ],
      builder: (ctx, child) {
        final navigationService = locator<NavigationService>();

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: Strings.appName,
          theme: lightTheme,
          themeMode: ThemeMode.light,
          initialRoute: navigationService.initialRoute,
          routes: navigationRoutes,
        );
      },
    );
  }
}
