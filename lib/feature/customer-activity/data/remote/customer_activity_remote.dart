import 'package:flamingo/feature/customer-activity/data/model/create_advertisement_activity_request.dart';
import 'package:flamingo/feature/customer-activity/data/model/create_user_activity_request.dart';
import 'package:flamingo/feature/customer-activity/data/model/customer_count_info_response.dart';

abstract class CustomerActivityRemote {
  Future<CustomerCountInfoResponse> getCustomerCountInfo();
  Future<void> createUserActivity(CreateUserActivityRequest request);
  Future<void> createAdvertisementActivity(
      CreateAdvertisementActivityRequest request);
}
