import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flamingo/shared/shared.dart';

final ThemeData lightTheme = ThemeData(
  primaryColor: AppColors.primaryDark,
  colorScheme: const ColorScheme.light(
    primary: AppColors.primaryDark,
    secondary: AppColors.secondaryDark,
  ),
  cardColor: AppColors.grayLighter,
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),
  fontFamily: 'NunitoSans',
  iconTheme: const IconThemeData(color: AppColors.black),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.white,
    selectedIconTheme: IconThemeData(
      color: AppColors.black,
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.white,
    titleTextStyle: TypographyStyles.titleLarge.copyWith(
      color: AppColors.black,
    ),
    elevation: 0,
    iconTheme: const IconThemeData(color: AppColors.black),
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: AppColors.white,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  ),
  scaffoldBackgroundColor: AppColors.white,
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: AppColors.black,
  ),
  textTheme: TextTheme(
    displayLarge: TypographyStyles.displayLarge.copyWith(
      color: AppColors.black,
    ),
    displayMedium: TypographyStyles.displayMedium.copyWith(
      color: AppColors.black,
    ),
    displaySmall: TypographyStyles.displaySmall.copyWith(
      color: AppColors.black,
    ),
    headlineMedium: TypographyStyles.headlineMedium.copyWith(
      color: AppColors.black,
    ),
    headlineSmall: TypographyStyles.headlineSmall.copyWith(
      color: AppColors.black,
    ),
    titleLarge: TypographyStyles.titleLarge.copyWith(
      color: AppColors.black,
    ),
    titleMedium: TypographyStyles.titleMedium.copyWith(
      color: AppColors.black,
    ),
    titleSmall: TypographyStyles.titleSmall.copyWith(
      color: AppColors.black,
    ),
    bodyLarge: TypographyStyles.bodyLarge.copyWith(
      color: AppColors.black,
    ),
    bodyMedium: TypographyStyles.bodyMedium.copyWith(
      color: AppColors.black,
    ),
    labelLarge: TypographyStyles.labelLarge.copyWith(
      color: AppColors.black,
    ),
    bodySmall: TypographyStyles.bodySmall.copyWith(
      color: AppColors.black,
    ),
    labelSmall: TypographyStyles.labelSmall.copyWith(
      color: AppColors.black,
    ),
  ),
);
