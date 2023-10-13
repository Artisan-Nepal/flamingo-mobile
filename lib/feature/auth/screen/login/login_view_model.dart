import 'package:flutter/material.dart';
import 'package:flamingo/feature/feature.dart';
import 'package:flamingo/shared/shared.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _loginRepository;

  LoginViewModel({required AuthRepository authRepository})
      : _loginRepository = authRepository;

  late LoginResponse loginResponse;

  Response<LoginResponse> loginUseCase = Response<LoginResponse>();

  void setLoginUseCase(Response<LoginResponse> response) {
    loginUseCase = response;
    notifyListeners();
  }

  Future<void> login(LoginRequest request) async {
    setLoginUseCase(Response.loading());
    try {
      loginResponse = await _loginRepository.login(request);
      setLoginUseCase(Response.complete(loginResponse));
    } on Exception catch (exception) {
      setLoginUseCase(Response.error(exception));
    }
  }
}
