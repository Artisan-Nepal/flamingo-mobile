import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/order/data/model/create_order.dart';
import 'package:flamingo/feature/order/data/model/order.dart';
import 'package:flamingo/feature/order/data/model/payment_method.dart';
import 'package:flamingo/feature/order/data/model/shipping_method.dart';

abstract class OrderRemote {
  Future<FetchResponse<ShippingMethod>> getShippingMethods();
  Future<FetchResponse<PaymentMethod>> getPaymentMethods();
  Future placeOrder(CreateOrderRequest request);
  Future<FetchResponse<Order>> getUserOrders(String customerId);
}
