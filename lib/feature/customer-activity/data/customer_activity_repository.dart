import 'package:flamingo/feature/customer-activity/data/model/customer_count_info_response.dart';

abstract class CustomerActivityRepository {
  Future<CustomerCountInfoResponse> getCustomerCountInfo();
  Future<void> createUserActivity({
    String? sellerId,
    String? productId,
    required String activityType,
  });
  Future<void> createAdvertisementActivity({
    required String advertisementId,
    String? productId,
    required String activityType,
  });
}
