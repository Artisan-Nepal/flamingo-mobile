import 'package:flamingo/feature/order/data/model/payment_method.dart';
import 'package:flamingo/feature/order/data/model/shipping_method.dart';
import 'package:flamingo/feature/order/data/order_repository.dart';
import 'package:flutter/cupertino.dart';

class PlaceOrderViewModel extends ChangeNotifier {
  final OrderRepository _orderRepository;

  PlaceOrderViewModel({required OrderRepository orderRepository})
      : _orderRepository = orderRepository;

  int _orderIndex = 0;
  ShippingMethod? _selectedShippingMethod;
  PaymentMethod? _selectedPaymentMethod;

  int get orderIndex => _orderIndex;
  ShippingMethod? get selectedShippingMethod => _selectedShippingMethod;
  PaymentMethod? get selectedPaymentMethod => _selectedPaymentMethod;

  incOrderIndex() {
    _orderIndex++;
    notifyListeners();
  }

  setOrderIndex(int index) {
    _orderIndex = index;
    notifyListeners();
  }

  decOrderIndex() {
    _orderIndex--;
    notifyListeners();
  }

  setSelectedShippingMethod(ShippingMethod? shippingMethod) {
    _selectedShippingMethod = shippingMethod;
    notifyListeners();
  }

  setSelectedPaymentMethod(PaymentMethod? paymentMethod) {
    _selectedPaymentMethod = paymentMethod;
    notifyListeners();
  }

  int getShippingFee() {
    if (_selectedShippingMethod == null) {
      return 0;
    } else {
      return _selectedShippingMethod!.cost;
    }
  }

  // placeUserOrder(int userCartLength, UserAddressModel? selectedShippingAddress,
  //     UserAddressModel? selectedBillingAddress, Function callback) async {
  //   _checkingOut = true;
  //   notifyListeners();

  //   // whether to clear user cart or not by checking if all the products are selected for checkout
  //   bool clearCart = _selectedCartList.length == userCartLength;
  //   var placeOrderModel = PlaceOrderModel(
  //       couponDiscount: _couponDiscount,
  //       billingAddressId: selectedBillingAddress!.id,
  //       shippingAddressId: selectedShippingAddress!.id,
  //       paymentType: _selectedPaymentMethod!.paymentModeId,
  //       productDetails: List<int>.from(
  //         _selectedCartList.map(
  //           (selectedCart) => selectedCart.id,
  //         ),
  //       ),
  //       shippingMethodId: _selectedShippingMethod!.id);
  //   var apiResponse = await checkoutRepo.placeUserOrder(placeOrderModel);
  //   if (apiResponse.status == Status.success) {
  //     _selectedCartList = [];
  //     _couponDiscount = 0;
  //     callback(true, apiResponse.message, clearCart);
  //   } else {
  //     callback(false, apiResponse.message, false);
  //   }
  //   _checkingOut = false;
  //   notifyListeners();
  // }
}
