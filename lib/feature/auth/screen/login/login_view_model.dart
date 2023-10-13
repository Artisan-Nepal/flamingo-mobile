import 'package:flamingo/feature/feature.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _loginRepository;

  LoginViewModel({required AuthRepository authRepository})
      : _loginRepository = authRepository;
}
