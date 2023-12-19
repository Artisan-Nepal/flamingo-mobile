import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/customer-activity/data/model/wishlist_item.dart';
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
}
