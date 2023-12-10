import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/order/data/model/payment_method.dart';
import 'package:flamingo/feature/order/data/model/shipping_method.dart';
import 'package:flamingo/feature/order/data/order_repository.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/cupertino.dart';

class CheckoutMethodViewModel extends ChangeNotifier {
  final OrderRepository _orderRepository;

  CheckoutMethodViewModel({required OrderRepository orderRepository})
      : _orderRepository = orderRepository;

  Response<FetchResponse<ShippingMethod>> _shippingMethodUseCase =
      Response<FetchResponse<ShippingMethod>>();
  Response<FetchResponse<ShippingMethod>> get shippingMethodUseCase =>
      _shippingMethodUseCase;
  Response<FetchResponse<PaymentMethod>> _paymentMethodUseCase =
      Response<FetchResponse<PaymentMethod>>();
  Response<FetchResponse<PaymentMethod>> get paymentMethodUseCase =>
      _paymentMethodUseCase;

  void setShippingMethodUseCase(
      Response<FetchResponse<ShippingMethod>> response) {
    _shippingMethodUseCase = response;
    notifyListeners();
  }

  void setPaymentMethodUseCase(
      Response<FetchResponse<PaymentMethod>> response) {
    _paymentMethodUseCase = response;
    notifyListeners();
  }

  Future<void> getShippingMethods() async {
    try {
      setShippingMethodUseCase(Response.loading());
      final response = await _orderRepository.getShippingMethods();
      setShippingMethodUseCase(Response.complete(response));
    } catch (exception) {
      setShippingMethodUseCase(Response.error(exception));
    }
  }

  Future<void> getPaymentMethods() async {
    try {
      setPaymentMethodUseCase(Response.loading());
      final response = await _orderRepository.getPaymentMethods();
      setPaymentMethodUseCase(Response.complete(response));
    } catch (exception) {
      setPaymentMethodUseCase(Response.error(exception));
    }
  }
}
