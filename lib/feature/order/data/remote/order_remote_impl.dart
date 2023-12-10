import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/order/data/model/payment_method.dart';
import 'package:flamingo/feature/order/data/model/shipping_method.dart';
import 'package:flamingo/feature/order/data/remote/order_remote.dart';

class OrderRemoteImpl implements OrderRemote {
  // ignore: unused_field
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
}
