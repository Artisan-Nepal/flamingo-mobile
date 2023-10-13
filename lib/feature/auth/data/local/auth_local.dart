abstract class AuthLocal {
  Future<void> setAccessToken(String accessToken);
  Future<String?> getAccessToken();
  Future<void> setUserId(int userId);
  Future<String?> getUserId();
  Future<void> setIsFirstTime(bool value);
}
