import 'package:flamingo/feature/customer-activity/data/customer_activity_repository.dart';
import 'package:flamingo/feature/customer-activity/data/model/wishlist_item.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/cupertino.dart';

class CustomerActivityViewModel extends ChangeNotifier {
  final CustomerActivityRepository _customerActivityRepository;

  CustomerActivityViewModel(
      {required CustomerActivityRepository customerActivityRepository})
      : _customerActivityRepository = customerActivityRepository;

  Response<CustomerCountInfoResponse> _customerCountInfoUseCase =
      Response<CustomerCountInfoResponse>(
          data: CustomerCountInfoResponse(
    cartCount: 0,
    orderCount: 0,
    wishlistCount: 0,
  ));

  int get cartCount => _customerCountInfoUseCase.data?.cartCount ?? 0;
  int get wishlistCount => _customerCountInfoUseCase.data?.wishlistCount ?? 0;
  int get orderCount => _customerCountInfoUseCase.data?.orderCount ?? 0;

  void setCartUseCase(Response<CustomerCountInfoResponse> response) {
    _customerCountInfoUseCase = response;
    notifyListeners();
  }

  Future<void> getCustomerCountInfo() async {
    try {
      setCartUseCase(Response.loading());
      final response = await _customerActivityRepository.getCustomerCountInfo();
      setCartUseCase(Response.complete(response));
    } catch (exception) {
      setCartUseCase(Response.error(exception));
    }
  }
}
