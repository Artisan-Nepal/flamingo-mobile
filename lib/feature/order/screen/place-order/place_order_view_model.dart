import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/address/data/model/address.dart';
import 'package:flamingo/feature/cart/data/model/cart_item.dart';
import 'package:flamingo/feature/customer-activity/create_activity_view_model.dart';
import 'package:flamingo/feature/customer-activity/customer_activity_view_model.dart';
import 'package:flamingo/feature/order/data/model/create_order_request.dart';
import 'package:flamingo/feature/order/data/model/initiate_online_checkout_request%20copy.dart';
import 'package:flamingo/feature/order/data/model/initiate_online_checkout_response.dart';
import 'package:flamingo/feature/order/data/model/payment_method.dart';
import 'package:flamingo/feature/order/data/model/shipping_method.dart';
import 'package:flamingo/feature/order/data/order_repository.dart';
import 'package:flamingo/shared/constant/user_activity_type.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/cupertino.dart';

class PlaceOrderViewModel extends ChangeNotifier {
  final OrderRepository _orderRepository;

  PlaceOrderViewModel({required OrderRepository orderRepository})
      : _orderRepository = orderRepository;

  int _orderIndex = 0;
  ShippingMethod? _selectedShippingMethod;
  PaymentMethod? _selectedPaymentMethod;
  Address? _selectedShippingAddress;
  Address? _selectedBillingAddress;
  Response _placeOrderUseCase = Response();
  Response<InitiateOnlineCheckoutResponse> _initiateOnlineCheckoutUseCase =
      Response();
  List<CartItem> _items = [];

  int get orderIndex => _orderIndex;
  ShippingMethod? get selectedShippingMethod => _selectedShippingMethod;
  PaymentMethod? get selectedPaymentMethod => _selectedPaymentMethod;
  Address? get selectedShippingAddress => _selectedShippingAddress;
  Address? get selectedBillingAddress => _selectedBillingAddress;
  Response get placeOrderUseCase => _placeOrderUseCase;
  Response<InitiateOnlineCheckoutResponse> get initiateOnlineCheckoutUseCase =>
      _initiateOnlineCheckoutUseCase;
  List<CartItem> get items => _items;

  void setCartItems(List<CartItem> items) {
    _items = items;
  }

  void setPlaceOrderUseCase(Response response) {
    _placeOrderUseCase = response;
    notifyListeners();
  }

  void setInitiateOnlineCheckoutUseCase(
      Response<InitiateOnlineCheckoutResponse> response) {
    _initiateOnlineCheckoutUseCase = response;
    notifyListeners();
  }

  setSelectedShippingAddress(Address address) {
    _selectedShippingAddress = address;
    notifyListeners();
  }

  setSelectedBillingAddress(Address address) {
    _selectedBillingAddress = address;
    notifyListeners();
  }

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

  Future<void> initateOnlinePayment() async {
    try {
      setInitiateOnlineCheckoutUseCase(Response.loading());
      final response = await _orderRepository.initateOnlineCheckout(
        InitiateOnlineCheckoutRequest(
          paymentMethodCode: _selectedPaymentMethod!.code,
          shippingMethodId: _selectedShippingMethod!.id,
        ),
      );
      setInitiateOnlineCheckoutUseCase(Response.complete(response));
    } catch (exception) {
      setInitiateOnlineCheckoutUseCase(Response.error(exception));
    }
  }

  Future<void> placeOrder({String? onlinePaymentToken}) async {
    try {
      setPlaceOrderUseCase(Response.loading());
      await _orderRepository.placeOrder(
        CreateOrderRequest(
          billingAddressId: _selectedBillingAddress!.id,
          shippingAddressId: _selectedShippingAddress!.id,
          paymentMethodCode: _selectedPaymentMethod!.code,
          shippingMethodId: _selectedShippingMethod!.id,
          onlinePaymentToken: onlinePaymentToken,
          checkoutId: _initiateOnlineCheckoutUseCase.data?.checkoutId,
        ),
      );
      locator<CustomerActivityViewModel>().getCustomerCountInfo();
      _logOrderActvity();
      setPlaceOrderUseCase(Response.complete(null));
    } catch (exception) {
      setPlaceOrderUseCase(Response.error(exception));
    }
  }

  _logOrderActvity() async {
    for (CartItem item in _items) {
      await locator<CreateActivityViewModel>().createUserActivity(
        productId: item.product.id,
        activityType: UserActivityType.orderProduct,
      );
    }
  }

  int get orderTotal {
    int price = 0;
    for (CartItem cart in items) {
      price = price + (cart.productVariant.price * cart.quantity);
    }
    return price;
  }

  int get shippingCost {
    return (_selectedShippingMethod?.cost ?? 0) * items.length;
  }

  int get netTotal {
    return orderTotal + shippingCost;
  }

  String get orderItemIds {
    return items.map((i) => i.productVariant.id).join(',');
  }

  String get orderItemNames {
    return items.map((i) => i.product.title).join(',');
  }
}
