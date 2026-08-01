import 'package:flamingo/data/local/local_storage_client.dart';
import 'package:flamingo/data/local/local_storage_keys.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Encrypted (iOS Keychain / Android Keystore) store for the auth access
/// token — the one credential that must not sit in plaintext SharedPreferences.
///
/// Includes a one-time silent migration of a token left in the old
/// SharedPreferences location, so upgrading users are NOT logged out. Reads
/// fail gracefully (rare Android restore corruption) as "no token" -> the user
/// simply logs in again; never a crash or prompt.
class SecureTokenStore {
  final FlutterSecureStorage _secure;
  final LocalStorageClient _legacySharedPref;

  SecureTokenStore({required LocalStorageClient legacySharedPref})
      : _legacySharedPref = legacySharedPref,
        _secure = const FlutterSecureStorage();

  Future<String?> getToken() async {
    try {
      final token = await _secure.read(key: LocalStorageKeys.accessToken);
      if (token != null) return token;
    } catch (_) {
      // Corrupted secure store (rare Android restore case): reset it so future
      // writes succeed, then fall through to "no token".
      try {
        await _secure.deleteAll();
      } catch (_) {}
    }
    // One-time migration from the old plaintext SharedPreferences location.
    final legacy =
        await _legacySharedPref.getString(LocalStorageKeys.accessToken);
    if (legacy != null) {
      await setToken(legacy);
      await _legacySharedPref.remove(LocalStorageKeys.accessToken);
      return legacy;
    }
    return null;
  }

  Future<void> setToken(String token) async {
    await _secure.write(key: LocalStorageKeys.accessToken, value: token);
  }

  Future<void> removeToken() async {
    try {
      await _secure.delete(key: LocalStorageKeys.accessToken);
    } catch (_) {}
    // Clean up any legacy copy too.
    await _legacySharedPref.remove(LocalStorageKeys.accessToken);
  }

  Future<bool> hasToken() async => (await getToken()) != null;

  // Refresh token (also encrypted). Backs the silent access-token refresh in
  // DioApiClientImpl; longer-lived than the access token.
  Future<String?> getRefreshToken() async {
    try {
      return await _secure.read(key: LocalStorageKeys.refreshToken);
    } catch (_) {
      return null;
    }
  }

  Future<void> setRefreshToken(String token) async {
    await _secure.write(key: LocalStorageKeys.refreshToken, value: token);
  }

  Future<void> removeRefreshToken() async {
    try {
      await _secure.delete(key: LocalStorageKeys.refreshToken);
    } catch (_) {}
  }

  // Clear the whole session (both tokens) - used on a failed refresh / logout.
  Future<void> clearSession() async {
    await removeToken();
    await removeRefreshToken();
  }
}
