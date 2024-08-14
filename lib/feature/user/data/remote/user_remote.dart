import 'package:flamingo/feature/user/data/customer.dart';
import 'package:flamingo/feature/user/data/model/create_device_request.dart';
import 'package:flamingo/feature/user/data/model/update_device_request.dart';
import 'package:flamingo/feature/user/data/model/update_user_request.dart';

abstract class UserRemote {
  Future updateCustomer(String customerId, UpdateUserRequest request);
  Future<Customer> getCustomer(String customerId);
  Future<void> createDevice(CreateDeviceRequest request);
  Future<void> updateDevice(UpdateDeviceRequest request);
}
