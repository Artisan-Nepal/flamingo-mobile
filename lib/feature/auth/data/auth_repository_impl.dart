import 'package:flamingo/feature/feature.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocal _authLocal;
  final AuthRemote _authRemote;

  AuthRepositoryImpl(
      {required AuthLocal authLocal, required AuthRemote authRemote})
      : _authLocal = authLocal,
        _authRemote = authRemote;

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    var response = await _authRemote.login(
        request.username, request.password, request.apkVersion);
    _saveUserInfo(response);
    return response;
  }

  Future<void> _saveUserInfo(LoginResponse response) async {
    await _authLocal.setAccessToken(response.token);
    await _authLocal.setUserId(response.user.id);
  }
}
