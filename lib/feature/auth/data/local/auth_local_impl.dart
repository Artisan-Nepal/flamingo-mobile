import 'package:flamingo/feature/feature.dart';
import 'package:flamingo/data/local/local.dart';
import 'package:flamingo/feature/user/data/customer.dart';

class AuthLocalImpl implements AuthLocal {
  final LocalStorageClient _sharedPrefManager;
  final SecureTokenStore _tokenStore;

  AuthLocalImpl({
    required LocalStorageClient sharedPrefManager,
    required SecureTokenStore tokenStore,
  })  : _sharedPrefManager = sharedPrefManager,
        _tokenStore = tokenStore;

  @override
  Future<String?> getAccessToken() async {
    // Encrypted store (Keychain/Keystore); migrates any legacy plaintext token.
    return await _tokenStore.getToken();
  }

  @override
  Future<void> setAccessToken(String accessToken) async {
    await _tokenStore.setToken(accessToken);
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
    return await _tokenStore.removeToken();
  }

  @override
  Future removeUser() async {
    return await _sharedPrefManager.remove(LocalStorageKeys.user);
  }

  @override
  Future<String?> getGuestId() async {
    return await _sharedPrefManager.getString(LocalStorageKeys.guestId);
  }

  @override
  Future removeGuestId() async {
    return await _sharedPrefManager.remove(LocalStorageKeys.guestId);
  }

  @override
  Future<void> setGuestId(String value) async {
    return await _sharedPrefManager.setString(LocalStorageKeys.guestId, value);
  }
}
