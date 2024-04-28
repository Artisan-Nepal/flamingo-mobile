import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/order/data/model/create_order_request.dart';
import 'package:flamingo/feature/order/data/model/initiate_online_checkout_request%20copy.dart';
import 'package:flamingo/feature/order/data/model/initiate_online_checkout_response.dart';
import 'package:flamingo/feature/order/data/model/order.dart';
import 'package:flamingo/feature/order/data/model/order_status_log.dart';
import 'package:flamingo/feature/order/data/model/payment_method.dart';
import 'package:flamingo/feature/order/data/model/shipping_method.dart';

abstract class OrderRemote {
  Future<FetchResponse<ShippingMethod>> getShippingMethods();
  Future<FetchResponse<PaymentMethod>> getPaymentMethods();
  Future<InitiateOnlineCheckoutResponse> initateOnlineCheckout(
      InitiateOnlineCheckoutRequest request);
  Future placeOrder(CreateOrderRequest request);
  Future<FetchResponse<Order>> getUserOrders(String customerId);
  Future<List<OrderStatusLog>> trackOrder(String orderId);
}
