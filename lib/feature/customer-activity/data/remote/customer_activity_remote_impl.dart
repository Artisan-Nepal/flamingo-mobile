import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/customer-activity/data/model/create_advertisement_activity_request.dart';
import 'package:flamingo/feature/customer-activity/data/model/create_user_activity_request.dart';
import 'package:flamingo/feature/customer-activity/data/model/customer_count_info_response.dart';
import 'package:flamingo/feature/customer-activity/data/remote/customer_activity_remote.dart';

class CustomerActivityRemoteImpl implements CustomerActivityRemote {
  final ApiClient _apiClient;

  CustomerActivityRemoteImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<CustomerCountInfoResponse> getCustomerCountInfo() async {
    final apiResponse = await _apiClient.get(ApiUrls.customersCountInfo);
    return CustomerCountInfoResponse.fromJson(apiResponse.data);
  }

  @override
  Future<void> createAdvertisementActivity(
      CreateAdvertisementActivityRequest request) async {
    await _apiClient.post(
      ApiUrls.advertisementActivity,
      body: request.toJson(),
    );
  }

  @override
  Future<void> createUserActivity(CreateUserActivityRequest request) async {
    await _apiClient.post(
      ApiUrls.userActivity,
      body: request.toJson(),
    );
  }
}
