import 'package:flamingo/feature/user/data/customer.dart';

abstract class AuthLocal {
  Future<void> setAccessToken(String accessToken);
  Future<String?> getAccessToken();
  Future<void> setIsFirstTime(bool value);
  Future<void> setUser(Customer user);
  Future<Customer?> getUser();
}
