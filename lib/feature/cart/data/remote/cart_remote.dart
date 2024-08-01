import 'package:flamingo/data/data.dart';
import 'package:flamingo/data/model/paginated_option.dart';
import 'package:flamingo/feature/cart/data/model/add_to_cart_request.dart';
import 'package:flamingo/feature/cart/data/model/cart.dart';
import 'package:flamingo/feature/cart/data/model/cart_item.dart';
import 'package:flamingo/feature/cart/data/model/update_cart_request.dart';

abstract class CartRemote {
  Future<Cart> addToCart(AddToCartRequest request);
  Future<FetchResponse<CartItem>> getUserCart(
      String customerId, PaginationOption? paginationOption);
  Future updateCart(String cartId, UpdateCartRequest request);
  Future deleteCart(String cartId);
}
