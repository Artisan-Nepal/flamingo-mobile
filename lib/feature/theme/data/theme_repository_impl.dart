import 'package:flutter/material.dart';
import 'package:flamingo/feature/feature.dart';
import 'package:flamingo/shared/shared.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeLocal _themeLocal;

  ThemeRepositoryImpl({required ThemeLocal themeLocal})
      : _themeLocal = themeLocal;

  @override
  Future<ThemeMode> getTheme() async {
    String themeMode = await _themeLocal.getThemeMode() ?? ThemeMode.light.name;
    return themeModeEnumFromString(themeMode);
  }

  @override
  Future<void> setTheme(ThemeMode themeMode) async {
    await _themeLocal.setThemeMode(themeMode.name);
  }
}
