import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/user/data/customer.dart';
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
}
