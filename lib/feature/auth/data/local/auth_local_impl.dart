import 'package:flamingo/feature/feature.dart';
import 'package:flamingo/data/local/local.dart';
import 'package:flamingo/feature/user/data/customer.dart';

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

  @override
  Future<void> setUser(Customer user) async {
    await _sharedPrefManager.setObject(LocalStorageKeys.user, user);
  }

  @override
  Future<Customer?> getUser() async {
    return await _sharedPrefManager.getObject(
        LocalStorageKeys.user, Customer.fromJson);
  }

  @override
  Future removeAccessToken() async {
    return await _sharedPrefManager.remove(LocalStorageKeys.accessToken);
  }

  @override
  Future removeUser() async {
    return await _sharedPrefManager.remove(LocalStorageKeys.user);
  }
}
