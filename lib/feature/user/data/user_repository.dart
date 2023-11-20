import 'package:flamingo/feature/user/data/model/update_user_request.dart';
import 'package:flamingo/feature/user/data/customer.dart';

abstract class UserRepository {
  Future updateCustomer(UpdateUserRequest request);
  Future<Customer> getCustomer();
}
