import 'package:flamingo/feature/feature.dart';

abstract class AuthRepository {
  Future<LoginResponse> login(LoginRequest request);
}
