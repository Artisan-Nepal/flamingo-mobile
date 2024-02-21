import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/auth/auth_view_model.dart';
import 'package:flamingo/feature/user/data/model/update_user_request.dart';
import 'package:flamingo/feature/user/data/user_repository.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class UpdateUserViewModel extends ChangeNotifier {
  final UserRepository _userRepository;

  UpdateUserViewModel({
    required UserRepository userRepository,
  }) : _userRepository = userRepository;

  Response _updateUserHandlerUseCase = Response();

  Response get updateUserHandlerUseCase => _updateUserHandlerUseCase;

  void setUpdateUserUseCase(Response response) {
    _updateUserHandlerUseCase = response;
    notifyListeners();
  }

  Future<void> updateUser(UpdateUserRequest request) async {
    try {
      setUpdateUserUseCase(Response.loading());
      await _userRepository.updateCustomer(
          request); // customer returned here doesn't have all the required params
      locator<AuthViewModel>().syncRemotely();
      setUpdateUserUseCase(Response.complete(null));
    } catch (exception) {
      setUpdateUserUseCase(Response.error(exception));
    }
  }
}
