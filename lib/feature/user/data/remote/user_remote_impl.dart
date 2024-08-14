import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/user/data/customer.dart';
import 'package:flamingo/feature/user/data/model/create_device_request.dart';
import 'package:flamingo/feature/user/data/model/update_device_request.dart';
import 'package:flamingo/feature/user/data/model/update_user_request.dart';
import 'package:flamingo/feature/user/data/remote/user_remote.dart';

class UserRemoteImpl implements UserRemote {
  final ApiClient _apiClient;

  UserRemoteImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<Customer> getCustomer(String customerId) async {
    final url = '${ApiUrls.customers}/$customerId';
    final apiResponse = await _apiClient.get(url);
    return Customer.fromJson(apiResponse.data);
  }

  @override
  Future updateCustomer(String customerId, UpdateUserRequest request) async {
    final url = '${ApiUrls.customers}/$customerId';
    await _apiClient.patch(url, body: request.toJson());
  }

  @override
  Future<void> createDevice(CreateDeviceRequest request) async {
    await _apiClient.post(ApiUrls.device, body: request.toJson());
  }

  @override
  Future<void> updateDevice(UpdateDeviceRequest request) async {
    await _apiClient.post(ApiUrls.deviceNotificationToken,
        body: request.toJson());
  }
}
