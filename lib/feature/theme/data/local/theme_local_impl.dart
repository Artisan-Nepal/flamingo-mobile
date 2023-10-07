import 'package:flamingo/feature/feature.dart';
import 'package:flamingo/data/data.dart';

class ThemeLocalImpl implements ThemeLocal {
  final LocalStorageClient _sharedPrefManager;

  ThemeLocalImpl({required LocalStorageClient sharedPrefManager})
      : _sharedPrefManager = sharedPrefManager;

  @override
  Future<String?> getThemeMode() async {
    return _sharedPrefManager.getString(LocalStorageKeys.themeMode);
  }

  @override
  Future<void> setThemeMode(String themeMode) async {
    _sharedPrefManager.setString(LocalStorageKeys.themeMode, themeMode);
  }
}
