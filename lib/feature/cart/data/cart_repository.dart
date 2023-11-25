import 'package:flamingo/feature/cart/data/model/add_to_cart_request.dart';
import 'package:flamingo/feature/cart/data/model/cart.dart';

abstract class CartRepository {
  Future<Cart> addToCart(AddToCartRequest request);
}
