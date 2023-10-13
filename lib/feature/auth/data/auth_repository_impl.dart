import 'package:flamingo/feature/feature.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocal _authLocal;
  final AuthRemote _authRemote;

  AuthRepositoryImpl(
      {required AuthLocal authLocal, required AuthRemote authRemote})
      : _authLocal = authLocal,
        _authRemote = authRemote;

  @override
  Future<void> onBoard() async {
    await _authLocal.setIsFirstTime(false);
  }
}
