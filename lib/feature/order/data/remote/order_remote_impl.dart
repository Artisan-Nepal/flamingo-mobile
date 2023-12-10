import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/order/data/remote/order_remote.dart';

class OrderRemoteImpl implements OrderRemote {
  // ignore: unused_field
  final ApiClient _apiClient;

  OrderRemoteImpl({required ApiClient apiClient}) : _apiClient = apiClient;
}
