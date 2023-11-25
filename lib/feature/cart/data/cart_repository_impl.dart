// ignore_for_file: unused_field
import 'package:flamingo/feature/cart/data/cart_repository.dart';
import 'package:flamingo/feature/cart/data/local/cart_local.dart';
import 'package:flamingo/feature/cart/data/model/add_to_cart_request.dart';
import 'package:flamingo/feature/cart/data/model/cart.dart';
import 'package:flamingo/feature/cart/data/remote/cart_remote.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocal _cartLocal;
  final CartRemote _cartRemote;

  CartRepositoryImpl({
    required CartLocal cartLocal,
    required CartRemote cartRemote,
  })  : _cartLocal = cartLocal,
        _cartRemote = cartRemote;

  @override
  Future<Cart> addToCart(AddToCartRequest request) async {
    return await _cartRemote.addToCart(request);
  }
}
