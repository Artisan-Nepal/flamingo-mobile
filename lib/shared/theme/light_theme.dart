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
      color: AppColors.grayDarker,
    ),
    elevation: 0,
    iconTheme: const IconThemeData(color: AppColors.grayDarker),
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
      color: AppColors.grayDarker,
    ),
    displayMedium: TypographyStyles.displayMedium.copyWith(
      color: AppColors.grayDarker,
    ),
    displaySmall: TypographyStyles.displaySmall.copyWith(
      color: AppColors.grayDarker,
    ),
    headlineMedium: TypographyStyles.headlineMedium.copyWith(
      color: AppColors.grayDarker,
    ),
    headlineSmall: TypographyStyles.headlineSmall.copyWith(
      color: AppColors.grayDarker,
    ),
    titleLarge: TypographyStyles.titleLarge.copyWith(
      color: AppColors.grayDarker,
    ),
    titleMedium: TypographyStyles.titleMedium.copyWith(
      color: AppColors.grayDarker,
    ),
    titleSmall: TypographyStyles.titleSmall.copyWith(
      color: AppColors.grayDarker,
    ),
    bodyLarge: TypographyStyles.bodyLarge.copyWith(
      color: AppColors.grayDarker,
    ),
    bodyMedium: TypographyStyles.bodyMedium.copyWith(
      color: AppColors.grayDarker,
    ),
    labelLarge: TypographyStyles.labelLarge.copyWith(
      color: AppColors.grayDarker,
    ),
    bodySmall: TypographyStyles.bodySmall.copyWith(
      color: AppColors.grayDarker,
    ),
    labelSmall: TypographyStyles.labelSmall.copyWith(
      color: AppColors.grayDarker,
    ),
  ),
);
