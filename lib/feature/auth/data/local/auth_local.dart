abstract class AuthLocal {
  Future<void> setAccessToken(String accessToken);
  Future<String?> getAccessToken();
  Future<void> setIsFirstTime(bool value);
}
