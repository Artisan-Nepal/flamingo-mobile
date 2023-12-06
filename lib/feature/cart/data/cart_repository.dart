import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/cart/data/model/add_to_cart_request.dart';
import 'package:flamingo/feature/cart/data/model/cart.dart';
import 'package:flamingo/feature/cart/data/model/cart_item.dart';

abstract class CartRepository {
  Future<Cart> addToCart(AddToCartRequest request);
  Future<FetchResponse<CartItem>> getUserCart();
}
