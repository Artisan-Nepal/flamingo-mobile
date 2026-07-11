import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/order/data/model/apply_coupon_response.dart';
import 'package:flamingo/feature/order/data/model/create_order_request.dart';
import 'package:flamingo/feature/order/data/model/khalti_initiate_request.dart';
import 'package:flamingo/feature/order/data/model/khalti_initiate_response.dart';
import 'package:flamingo/feature/order/data/model/order.dart';
import 'package:flamingo/feature/order/data/model/order_status_log.dart';
import 'package:flamingo/feature/order/data/model/payment_method.dart';
import 'package:flamingo/feature/order/data/model/saved_coupon.dart';
import 'package:flamingo/feature/order/data/model/shipping_method.dart';
import 'package:flamingo/feature/order/data/remote/order_remote.dart';

class OrderRemoteImpl implements OrderRemote {
  final ApiClient _apiClient;

  OrderRemoteImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<FetchResponse<PaymentMethod>> getPaymentMethods() async {
    final apiResponse = await _apiClient.get(ApiUrls.paymentMethods);
    return FetchResponse.fromJson(
      apiResponse.data,
      PaymentMethod.fromJsonList,
    );
  }

  @override
  Future<FetchResponse<ShippingMethod>> getShippingMethods() async {
    final apiResponse = await _apiClient.get(ApiUrls.shippingMethods);
    return FetchResponse.fromJson(
      apiResponse.data,
      ShippingMethod.fromJsonList,
    );
  }

  @override
  Future placeOrder(CreateOrderRequest request) async {
    await _apiClient.post(ApiUrls.orders, body: request.toJson());
  }

  @override
  Future<FetchResponse<Order>> getUserOrders(String customerId) async {
    final url = '${ApiUrls.customerOrders}/$customerId';
    final apiResponse = await _apiClient.get(url);
    return FetchResponse.fromJson(
      apiResponse.data,
      Order.fromJsonList,
    );
  }

  @override
  Future<List<OrderStatusLog>> trackOrder(String orderId) async {
    final url = ApiUrls.trackOrder.replaceFirst(":id", orderId);
    final apiReponse = await _apiClient.get(url);
    return OrderStatusLog.fromJsonList(apiReponse.data);
  }

  @override
  Future cancelOrder(String orderId) async {
    final url = ApiUrls.cancelOrder.replaceFirst(":id", orderId);
    await _apiClient.patch(url);
  }

  @override
  Future<KhaltiInitiateResponse> initiateKhaltiOrder(
      KhaltiInitiateRequest request) async {
    final apiResponse = await _apiClient.post(
      ApiUrls.khaltiInitiate,
      body: request.toJson(),
    );
    return KhaltiInitiateResponse.fromJson(apiResponse.data);
  }

  @override
  Future<List<String>> confirmKhaltiOrder(String pidx) async {
    final apiResponse = await _apiClient.post(
      ApiUrls.khaltiConfirm,
      body: {'pidx': pidx},
    );
    return List<String>.from(apiResponse.data['orderIds']);
  }

  @override
  Future<ApplyCouponResponse> validateCoupon(String code) async {
    final apiResponse = await _apiClient.post(
      ApiUrls.couponValidate,
      body: {'code': code},
    );
    return ApplyCouponResponse.fromJson(apiResponse.data);
  }

  @override
  Future<List<SavedCoupon>> getSavedCoupons() async {
    final apiResponse = await _apiClient.get(ApiUrls.savedCoupons);
    return SavedCoupon.fromJsonList(apiResponse.data);
  }
}
