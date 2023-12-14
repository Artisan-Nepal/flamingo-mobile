import 'package:flamingo/feature/address/data/model/address.dart';
import 'package:flamingo/feature/cart/data/model/cart_item.dart';
import 'package:flamingo/feature/order/data/model/create_order.dart';
import 'package:flamingo/feature/order/data/model/payment_method.dart';
import 'package:flamingo/feature/order/data/model/shipping_method.dart';
import 'package:flamingo/feature/order/data/order_repository.dart';
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
  List<CartItem> _items = [];

  int get orderIndex => _orderIndex;
  ShippingMethod? get selectedShippingMethod => _selectedShippingMethod;
  PaymentMethod? get selectedPaymentMethod => _selectedPaymentMethod;
  Address? get selectedShippingAddress => _selectedShippingAddress;
  Address? get selectedBillingAddress => _selectedBillingAddress;
  Response get placeOrderUseCase => _placeOrderUseCase;
  List<CartItem> get items => _items;

  void setCartItems(List<CartItem> items) {
    _items = items;
  }

  void setPlaceOrderUseCase(Response response) {
    _placeOrderUseCase = response;
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

  Future<void> placeOrder() async {
    try {
      setPlaceOrderUseCase(Response.loading());
      await _orderRepository.placeOrder(
        CreateOrderRequest(
          billingAddressId: _selectedBillingAddress!.id,
          shippingAddressId: _selectedShippingAddress!.id,
          paymentMethodId: _selectedPaymentMethod!.id,
          shippingMethodId: _selectedShippingMethod!.id,
        ),
      );
      setPlaceOrderUseCase(Response.complete(null));
    } catch (exception) {
      setPlaceOrderUseCase(Response.error(exception));
    }
  }

  int get subTotal {
    int price = 0;
    for (CartItem cart in items) {
      price = price + (cart.productVariant.price * cart.quantity);
    }
    return price;
  }

  int get orderTotal {
    return subTotal + (_selectedShippingMethod?.cost ?? 0);
  }
}
