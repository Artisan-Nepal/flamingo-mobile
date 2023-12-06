import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/cart/data/model/add_to_cart_request.dart';
import 'package:flamingo/feature/cart/data/model/cart.dart';
import 'package:flamingo/feature/cart/data/model/cart_item.dart';
import 'package:flamingo/feature/cart/data/remote/cart_remote.dart';

class CartRemoteImpl implements CartRemote {
  final ApiClient _apiClient;

  CartRemoteImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<Cart> addToCart(AddToCartRequest request) async {
    final apiResponse =
        await _apiClient.post(ApiUrls.carts, body: request.toJson());
    return Cart.fromJson(apiResponse.data);
  }

  @override
  Future<FetchResponse<CartItem>> getUserCart(String customerId) async {
    final url = '${ApiUrls.carts}/customer/$customerId';
    final apiResponse = await _apiClient.get(url);
    return FetchResponse.fromJson(
      apiResponse.data,
      CartItem.fromJsonList,
    );
  }
}
