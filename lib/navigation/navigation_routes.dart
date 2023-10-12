import 'package:flamingo/navigation/navigation_route_names.dart';
import 'package:flutter/material.dart';
import 'package:flamingo/feature/feature.dart';

final navigationRoutes = <String, WidgetBuilder>{
  NavigationRouteNames.onBoarding: (ctx) => const OnBoardingScreen(),
  NavigationRouteNames.login: (ctx) => const LoginScreen(),
  NavigationRouteNames.home: (ctx) => const HomeScreen(),
};
