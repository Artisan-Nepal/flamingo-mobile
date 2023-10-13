import 'package:flamingo/feature/feature.dart';
import 'package:flamingo/data/local/local.dart';

class AuthLocalImpl implements AuthLocal {
  final LocalStorageClient _sharedPrefManager;

  AuthLocalImpl({required LocalStorageClient sharedPrefManager})
      : _sharedPrefManager = sharedPrefManager;

  @override
  Future<String?> getAccessToken() async {
    return await _sharedPrefManager.getString(LocalStorageKeys.accessToken);
  }

  @override
  Future<void> setAccessToken(String accessToken) async {
    await _sharedPrefManager.setString(
        LocalStorageKeys.accessToken, accessToken);
  }

  @override
  Future<void> setIsFirstTime(bool value) async {
    await _sharedPrefManager.setBool(LocalStorageKeys.isFirstTime, value);
  }
}
