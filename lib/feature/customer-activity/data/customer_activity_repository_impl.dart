// ignore_for_file: unused_field

import 'package:flamingo/feature/auth/auth.dart';
import 'package:flamingo/feature/customer-activity/data/customer_activity_repository.dart';
import 'package:flamingo/feature/customer-activity/data/local/customer_activity_local.dart';
import 'package:flamingo/feature/customer-activity/data/model/wishlist_item.dart';
import 'package:flamingo/feature/customer-activity/data/remote/customer_activity_remote.dart';

class CustomerActivityRepositoryImpl implements CustomerActivityRepository {
  final CustomerActivityLocal _customerActivityLocal;
  final CustomerActivityRemote _customerActivityRemote;
  final AuthRepository _authRepository;

  CustomerActivityRepositoryImpl({
    required CustomerActivityLocal customerActivityLocal,
    required CustomerActivityRemote customerActivityRemote,
    required AuthRepository authRepository,
  })  : _customerActivityLocal = customerActivityLocal,
        _authRepository = authRepository,
        _customerActivityRemote = customerActivityRemote;

  @override
  Future<CustomerCountInfoResponse> getCustomerCountInfo() async {
    return await _customerActivityRemote.getCustomerCountInfo();
  }
}
