import 'package:flamingo/feature/order/data/model/order_status_log.dart';
import 'package:flamingo/feature/order/data/order_repository.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class OrderStatusViewModel extends ChangeNotifier {
  final OrderRepository _orderRepository;

  OrderStatusViewModel({required OrderRepository orderRepository})
      : _orderRepository = orderRepository;

  Response<List<OrderStatusLog>> _trackOrderStatusUseCase =
      Response<List<OrderStatusLog>>();

  Response<List<OrderStatusLog>> get trackOrderStatusUseCase =>
      _trackOrderStatusUseCase;

  void setTrackOrderStatusUseCase(Response<List<OrderStatusLog>> response) {
    _trackOrderStatusUseCase = response;
    notifyListeners();
  }

  Future<void> trackOrderStatus(String orderId) async {
    try {
      setTrackOrderStatusUseCase(Response.loading());
      final response = await _orderRepository.trackOrder(orderId);
      final lastStatus = response.last.status.code;
      if (lastStatus != 'DELIVERED' && lastStatus != 'CANCELLED') {
        response.add(
          OrderStatusLog(
            id: '',
            status: getNextOrderStatus(response.last.status.sequenceNumber),
            timestamp: DateTime.now(),
          ),
        );
      }
      setTrackOrderStatusUseCase(Response.complete(response));
    } catch (exception) {
      setTrackOrderStatusUseCase(Response.error(exception));
    }
  }
}
