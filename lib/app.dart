import 'package:flamingo/feature/auth/auth_view_model.dart';
import 'package:flamingo/feature/customer-activity/customer_activity_view_model.dart';
import 'package:flamingo/feature/product-story/product_story_engagement_view_model.dart';
import 'package:flamingo/feature/search/screen/text-search/search_view_model.dart';
import 'package:flamingo/feature/vendor/favourite_vendor_view_model.dart';
import 'package:flamingo/feature/wishlist/wishlist_view_model.dart';
import 'package:flamingo/navigation/navigation_route_names.dart';
import 'package:flutter/material.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/feature.dart';
import 'package:flamingo/navigation/navigation.dart';
import 'package:provider/provider.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

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
        ChangeNotifierProvider(create: (ctx) => locator<SearchViewModel>()),
        ChangeNotifierProvider(
            create: (ctx) => locator<ProductStoryEngagementViewModel>()),
        ChangeNotifierProvider(
            create: (ctx) => locator<FavouriteVendorViewModel>()),
        ChangeNotifierProvider(
            create: (ctx) => locator<CustomerActivityViewModel>()),
      ],
      builder: (ctx, child) {
        final navigationService = locator<NavigationService>();

        return KhaltiScope(
          publicKey: CommonConstants.khaltiPublicKey,
          builder: (context, navigatorKey) => MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: Strings.appName,
            theme: lightTheme,
            themeMode: ThemeMode.light,
            home: getInititalScreen(navigationService.initialRoute),
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('ne', 'NP'),
            ],
            localizationsDelegates: const [
              KhaltiLocalizations.delegate,
            ],
          ),
        );
      },
    );
  }

  Widget getInititalScreen(String initialRoute) {
    if (initialRoute == NavigationRouteNames.onBoarding)
      return OnBoardingScreen();
    if (initialRoute == NavigationRouteNames.login) return LoginScreen();
    if (initialRoute == NavigationRouteNames.dashboard)
      return DashboardScreen();
    return SizedBox();
  }
}
