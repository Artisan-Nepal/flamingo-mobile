import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flamingo/shared/shared.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: AppColors.primaryDark,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.primaryDark,
    secondary: AppColors.secondaryDark,
  ),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),
  fontFamily: 'NunitoSans',
  iconTheme: const IconThemeData(color: AppColors.white),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.black,
    selectedIconTheme: IconThemeData(
      color: AppColors.white,
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.black,
    titleTextStyle: TypographyStyles.titleLarge.copyWith(
      color: AppColors.grayLighter,
    ),
    iconTheme: const IconThemeData(color: AppColors.grayLighter),
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: AppColors.black,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
    elevation: 0,
  ),
  scaffoldBackgroundColor: AppColors.black,
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: AppColors.white,
  ),
  textTheme: TextTheme(
    displayLarge: TypographyStyles.displayLarge.copyWith(
      color: AppColors.grayLighter,
    ),
    displayMedium: TypographyStyles.displayMedium.copyWith(
      color: AppColors.grayLighter,
    ),
    displaySmall: TypographyStyles.displaySmall.copyWith(
      color: AppColors.grayLighter,
    ),
    headlineMedium: TypographyStyles.headlineMedium.copyWith(
      color: AppColors.grayLighter,
    ),
    headlineSmall: TypographyStyles.headlineSmall.copyWith(
      color: AppColors.grayLighter,
    ),
    titleLarge: TypographyStyles.titleLarge.copyWith(
      color: AppColors.grayLighter,
    ),
    titleMedium: TypographyStyles.titleMedium.copyWith(
      color: AppColors.grayLighter,
    ),
    titleSmall: TypographyStyles.titleSmall.copyWith(
      color: AppColors.grayLighter,
    ),
    bodyLarge: TypographyStyles.bodyLarge.copyWith(
      color: AppColors.grayLighter,
    ),
    bodyMedium: TypographyStyles.bodyMedium.copyWith(
      color: AppColors.grayLighter,
    ),
    labelLarge: TypographyStyles.labelLarge.copyWith(
      color: AppColors.grayLighter,
    ),
    bodySmall: TypographyStyles.bodySmall.copyWith(
      color: AppColors.grayLighter,
    ),
    labelSmall: TypographyStyles.labelSmall.copyWith(
      color: AppColors.grayLighter,
    ),
  ),
);
