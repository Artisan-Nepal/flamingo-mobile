import 'package:flamingo/feature/user/data/customer.dart';
import 'package:flamingo/feature/user/data/model/update_user_request.dart';

abstract class UserRemote {
  Future updateCustomer(String customerId, UpdateUserRequest request);
  Future<Customer> getCustomer(String customerId);
}
