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

  Response _updateVendorHandlerUseCase = Response();

  Response get updateVendorHandlerUseCase => _updateVendorHandlerUseCase;

  void setupdateVendorUseCase(Response response) {
    _updateVendorHandlerUseCase = response;
    notifyListeners();
  }

  Future<void> updateVendor(UpdateUserRequest request) async {
    try {
      setupdateVendorUseCase(Response.loading());
      await _userRepository.updateCustomer(
          request); // customer returned here doesn't have all the required params
      locator<AuthViewModel>().syncRemotely();
      setupdateVendorUseCase(Response.complete(null));
    } catch (exception) {
      setupdateVendorUseCase(Response.error(exception));
    }
  }
}
