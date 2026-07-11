import 'package:flamingo/feature/order/data/order_repository.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class OrderDetailViewModel extends ChangeNotifier {
  final OrderRepository _orderRepository;

  OrderDetailViewModel({required OrderRepository orderRepository})
      : _orderRepository = orderRepository;

  Response _cancelOrderUseCase = Response();

  Response get cancelOrderUseCase => _cancelOrderUseCase;

  void setCancelOrderUseCase(Response response) {
    _cancelOrderUseCase = response;
    notifyListeners();
  }

  Future<void> cancelOrder(String orderId) async {
    try {
      setCancelOrderUseCase(Response.loading());
      final response = await _orderRepository.cancelOrder(orderId);
      setCancelOrderUseCase(Response.complete(response));
    } catch (exception) {
      setCancelOrderUseCase(Response.error(exception));
    }
  }
}
