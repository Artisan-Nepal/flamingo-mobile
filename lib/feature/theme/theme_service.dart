import 'package:flutter/material.dart';
import 'package:flamingo/feature/feature.dart';

class ThemeService extends ChangeNotifier {
  final ThemeRepository _themeRepository;

  ThemeService({required ThemeRepository themeRepository})
      : _themeRepository = themeRepository;

  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool isLightMode(BuildContext context) {
    if (themeMode == ThemeMode.system) {
      return MediaQuery.of(context).platformBrightness == Brightness.light;
    } else {
      return themeMode == ThemeMode.light;
    }
  }

  Future<void> initializeTheme() async {
    _themeMode = await _themeRepository.getTheme();
    notifyListeners();
  }

  void setTheme(ThemeMode themeMode) async {
    _themeMode = themeMode;
    notifyListeners();
    await _themeRepository.setTheme(themeMode);
  }
}
