// ignore_for_file: unused_field

import 'package:flamingo/feature/auth/auth.dart';
import 'package:flamingo/feature/customer-activity/data/customer_activity_repository.dart';
import 'package:flamingo/feature/customer-activity/data/local/customer_activity_local.dart';
import 'package:flamingo/feature/customer-activity/data/model/create_advertisement_activity_request.dart';
import 'package:flamingo/feature/customer-activity/data/model/create_user_activity_request.dart';
import 'package:flamingo/feature/customer-activity/data/model/customer_count_info_response.dart';
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

  @override
  Future<void> createAdvertisementActivity(
      {required String advertisementId,
      String? productId,
      required String activityType}) async {
    final userId = (await _authRepository.getUserLocal())!.userId;
    await _customerActivityRemote.createAdvertisementActivity(
      CreateAdvertisementActivityRequest(
        userId: userId,
        advertisementId: advertisementId,
        productId: productId,
        activityType: activityType,
      ),
    );
  }

  @override
  Future<void> createUserActivity(
      {String? vendorId,
      String? productId,
      required String activityType}) async {
    final userId = (await _authRepository.getUserLocal())!.userId;
    return _customerActivityRemote.createUserActivity(
      CreateUserActivityRequest(
        userId: userId,
        vendorId: vendorId,
        productId: productId,
        activityType: activityType,
      ),
    );
  }
}
