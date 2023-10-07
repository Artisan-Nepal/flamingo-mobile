import 'package:flamingo/feature/feature.dart';

abstract class AuthRemote {
  Future<LoginResponse> login(
      String username, String password, String apkVersion);
}
