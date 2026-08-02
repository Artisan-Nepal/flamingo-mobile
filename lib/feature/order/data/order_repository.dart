import 'package:flamingo/data/model/fetch_response.dart';
import 'package:flamingo/feature/order/data/model/apply_coupon_response.dart';
import 'package:flamingo/feature/order/data/model/create_order_request.dart';
import 'package:flamingo/feature/order/data/model/delivery_quote.dart';
import 'package:flamingo/feature/order/data/model/khalti_initiate_request.dart';
import 'package:flamingo/feature/order/data/model/khalti_initiate_response.dart';
import 'package:flamingo/feature/order/data/model/order.dart';
import 'package:flamingo/feature/order/data/model/order_status_log.dart';
import 'package:flamingo/feature/order/data/model/payment_method.dart';
import 'package:flamingo/feature/order/data/model/saved_coupon.dart';
import 'package:flamingo/feature/order/data/model/shipping_method.dart';

abstract class OrderRepository {
  Future<FetchResponse<ShippingMethod>> getShippingMethods();
  Future<FetchResponse<PaymentMethod>> getPaymentMethods();
  Future placeOrder(CreateOrderRequest request);
  Future<FetchResponse<Order>> getUserOrders();
  Future<List<OrderStatusLog>> trackOrder(String orderId);
  Future cancelOrder(String orderId);
  Future<KhaltiInitiateResponse> initiateKhaltiOrder(KhaltiInitiateRequest request);
  Future<List<String>> confirmKhaltiOrder(String pidx);
  Future<ApplyCouponResponse> validateCoupon(String code);
  Future<List<SavedCoupon>> getSavedCoupons();
  Future<DeliveryQuote> getDeliveryQuote({
    required String shippingAddressId,
    required String shippingMethodId,
    List<String>? productVariantIds,
  });
}
