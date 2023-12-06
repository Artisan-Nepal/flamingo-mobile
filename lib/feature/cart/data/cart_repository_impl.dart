// ignore_for_file: unused_field
import 'package:flamingo/data/model/fetch_response.dart';
import 'package:flamingo/feature/auth/auth.dart';
import 'package:flamingo/feature/cart/data/cart_repository.dart';
import 'package:flamingo/feature/cart/data/local/cart_local.dart';
import 'package:flamingo/feature/cart/data/model/add_to_cart_request.dart';
import 'package:flamingo/feature/cart/data/model/cart.dart';
import 'package:flamingo/feature/cart/data/model/cart_item.dart';
import 'package:flamingo/feature/cart/data/remote/cart_remote.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocal _cartLocal;
  final CartRemote _cartRemote;
  final AuthRepository _authRepository;

  CartRepositoryImpl({
    required CartLocal cartLocal,
    required CartRemote cartRemote,
    required AuthRepository authRepository,
  })  : _cartLocal = cartLocal,
        _cartRemote = cartRemote,
        _authRepository = authRepository;

  @override
  Future<Cart> addToCart(AddToCartRequest request) async {
    return await _cartRemote.addToCart(request);
  }

  @override
  Future<FetchResponse<CartItem>> getUserCart() async {
    final customerId = (await _authRepository.getUserLocal())!.id;
    return await _cartRemote.getUserCart(customerId);
  }
}
