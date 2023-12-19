import 'package:flamingo/feature/customer-activity/data/model/wishlist_item.dart';

abstract class CustomerActivityRepository {
  Future<CustomerCountInfoResponse> getCustomerCountInfo();
}
