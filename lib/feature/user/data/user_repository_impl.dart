// ignore_for_file: unused_field

import 'package:flamingo/feature/feature.dart';
import 'package:flamingo/feature/user/data/local/user_local.dart';
import 'package:flamingo/feature/user/data/model/update_user_request.dart';
import 'package:flamingo/feature/user/data/customer.dart';
import 'package:flamingo/feature/user/data/user_repository.dart';
import 'package:flamingo/feature/user/data/remote/user_remote.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocal _userLocal;
  final UserRemote _userRemote;
  final AuthRepository _authRepository;

  UserRepositoryImpl({
    required UserLocal userLocal,
    required UserRemote userRemote,
    required AuthRepository authRepository,
  })  : _userLocal = userLocal,
        _userRemote = userRemote,
        _authRepository = authRepository;

  @override
  Future<Customer> getCustomer() async {
    final customerId = (await _authRepository.getUserLocal())!.id;
    final customer = await _userRemote.getCustomer(customerId);
    await _authRepository.setUserLocal(customer);
    return customer;
  }

  @override
  Future updateCustomer(UpdateUserRequest request) async {
    final customerId = (await _authRepository.getUserLocal())!.id;
    return await _userRemote.updateCustomer(customerId, request);
  }
}
