import 'package:flutter/material.dart';

abstract class ThemeRepository {
  Future<ThemeMode> getTheme();

  Future<void> setTheme(ThemeMode themeMode);
}
