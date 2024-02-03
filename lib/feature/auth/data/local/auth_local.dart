import 'package:flamingo/feature/user/data/customer.dart';

abstract class AuthLocal {
  Future<void> setAccessToken(String accessToken);
  Future<String?> getAccessToken();
  Future removeAccessToken();
  Future<void> setIsFirstTime(bool value);
  Future<void> setUser(Customer user);
  Future removeUser();
  Future<Customer?> getUser();
  Future<void> setGuestId(String value);
  Future removeGuestId();
  Future<String?> getGuestId();
}
