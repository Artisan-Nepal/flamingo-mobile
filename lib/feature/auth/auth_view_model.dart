import 'package:flamingo/feature/feature.dart';
import 'package:flamingo/feature/user/data/customer.dart';
import 'package:flamingo/feature/user/data/user_repository.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  AuthViewModel(
      {required AuthRepository authRepository,
      required UserRepository userRepository})
      : _authRepository = authRepository,
        _userRepository = userRepository {
    syncLocally();
  }

  late bool _isLoggedIn;
  Customer? _user;

  bool get isLoggedIn => _isLoggedIn;
  Customer? get user => _user;

  Future<void> syncLocally() async {
    _isLoggedIn = await _authRepository.getIsLoggedIn();
    _user = await _authRepository.getUserLocal();
    notifyListeners();
  }

  Future<void> syncRemotely() async {
    if (!(await _authRepository.getIsLoggedIn())) return;
    try {
      _user = await _userRepository.getCustomer();
    } catch (err) {
      debugPrint(
          'Failed to sync auth state remotely | Error: ${err.toString()}');
    }
    notifyListeners();
  }
}
