import 'package:flamingo/data/model/fetch_response.dart';
import 'package:flamingo/feature/order/data/model/create_order_request.dart';
import 'package:flamingo/feature/order/data/model/order.dart';
import 'package:flamingo/feature/order/data/model/order_status_log.dart';
import 'package:flamingo/feature/order/data/model/payment_method.dart';
import 'package:flamingo/feature/order/data/model/shipping_method.dart';

abstract class OrderRepository {
  Future<FetchResponse<ShippingMethod>> getShippingMethods();
  Future<FetchResponse<PaymentMethod>> getPaymentMethods();
  Future placeOrder(CreateOrderRequest request);
  Future<FetchResponse<Order>> getUserOrders();
  Future<List<OrderStatusLog>> trackOrder(String orderId);
}
