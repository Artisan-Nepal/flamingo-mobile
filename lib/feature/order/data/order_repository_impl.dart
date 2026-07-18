// ignore_for_file: unused_field
import 'package:flamingo/data/model/fetch_response.dart';
import 'package:flamingo/feature/auth/auth.dart';
import 'package:flamingo/feature/order/data/local/order_local.dart';
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
import 'package:flamingo/feature/order/data/order_repository.dart';
import 'package:flamingo/feature/order/data/remote/order_remote.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderLocal _orderLocal;
  final OrderRemote _orderRemote;
  final AuthRepository _authRepository;

  OrderRepositoryImpl({
    required OrderLocal orderLocal,
    required OrderRemote orderRemote,
    required AuthRepository authRepository,
  })  : _orderLocal = orderLocal,
        _orderRemote = orderRemote,
        _authRepository = authRepository;

  @override
  Future<FetchResponse<PaymentMethod>> getPaymentMethods() async {
    return await _orderRemote.getPaymentMethods();
  }

  @override
  Future<FetchResponse<ShippingMethod>> getShippingMethods() async {
    return await _orderRemote.getShippingMethods();
  }

  @override
  Future placeOrder(CreateOrderRequest request) async {
    return await _orderRemote.placeOrder(request);
  }

  @override
  Future<FetchResponse<Order>> getUserOrders() async {
    final customerId = (await _authRepository.getUserLocal())!.id;
    return await _orderRemote.getUserOrders(customerId);
  }

  @override
  Future<List<OrderStatusLog>> trackOrder(String orderId) async {
    return await _orderRemote.trackOrder(orderId);
  }

  @override
  Future cancelOrder(String orderId) async {
    return await _orderRemote.cancelOrder(orderId);
  }

  @override
  Future<KhaltiInitiateResponse> initiateKhaltiOrder(
      KhaltiInitiateRequest request) async {
    return await _orderRemote.initiateKhaltiOrder(request);
  }

  @override
  Future<List<String>> confirmKhaltiOrder(String pidx) async {
    return await _orderRemote.confirmKhaltiOrder(pidx);
  }

  @override
  Future<ApplyCouponResponse> validateCoupon(String code) async {
    return await _orderRemote.validateCoupon(code);
  }

  @override
  Future<List<SavedCoupon>> getSavedCoupons() async {
    return await _orderRemote.getSavedCoupons();
  }

  @override
  Future<DeliveryQuote> getDeliveryQuote({
    required String shippingAddressId,
    required String shippingMethodId,
  }) async {
    return await _orderRemote.getDeliveryQuote(
      shippingAddressId: shippingAddressId,
      shippingMethodId: shippingMethodId,
    );
  }
}
