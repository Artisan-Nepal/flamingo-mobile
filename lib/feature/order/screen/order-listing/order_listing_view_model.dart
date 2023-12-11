import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/order/data/model/order_item.dart';
import 'package:flamingo/feature/order/data/order_repository.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/cupertino.dart';

class OrderListingViewModel extends ChangeNotifier {
  final OrderRepository _orderRepository;

  OrderListingViewModel({required OrderRepository orderRepository})
      : _orderRepository = orderRepository;

  Response<FetchResponse<Order>> _orderUseCase =
      Response<FetchResponse<Order>>();
  Response<FetchResponse<Order>> get orderUseCase => _orderUseCase;

  void setOrderUseCase(Response<FetchResponse<Order>> response) {
    _orderUseCase = response;
    notifyListeners();
  }

  Future<void> getCart() async {
    try {
      setOrderUseCase(Response.loading());
      final response = await _orderRepository.getUserOrders();
      setOrderUseCase(Response.complete(response));
    } catch (exception) {
      setOrderUseCase(Response.error(exception));
    }
  }
}
