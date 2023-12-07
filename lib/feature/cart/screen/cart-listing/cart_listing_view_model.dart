import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/cart/data/cart_repository.dart';
import 'package:flamingo/feature/cart/data/model/cart_item.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/cupertino.dart';

class CartListingViewModel extends ChangeNotifier {
  final CartRepository _cartRepository;

  CartListingViewModel({required CartRepository cartRepository})
      : _cartRepository = cartRepository;

  Response<FetchResponse<CartItem>> _cartUseCase =
      Response<FetchResponse<CartItem>>();
  Response<FetchResponse<CartItem>> get cartUseCase => _cartUseCase;

  void setCartUseCase(Response<FetchResponse<CartItem>> response) {
    _cartUseCase = response;
    notifyListeners();
  }

  Future<void> getCart() async {
    try {
      setCartUseCase(Response.loading());
      final response = await _cartRepository.getUserCart();
      setCartUseCase(Response.complete(response));
    } catch (exception) {
      setCartUseCase(Response.error(exception));
    }
  }

  void removeFromCartState(String cartId) {
    cartUseCase.data?.rows.removeWhere((element) => element.id == cartId);
    notifyListeners();
  }

  void updateCartQuantity(String cartId, int quantity) {
    if (cartUseCase.data == null) return;
    final index =
        cartUseCase.data!.rows.indexWhere((element) => element.id == cartId);
    cartUseCase.data!.rows[index].quantity = quantity;
    notifyListeners();
  }
}
