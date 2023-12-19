import 'package:flamingo/feature/customer-activity/data/model/wishlist_item.dart';

abstract class CustomerActivityRemote {
  Future<CustomerCountInfoResponse> getCustomerCountInfo();
}
