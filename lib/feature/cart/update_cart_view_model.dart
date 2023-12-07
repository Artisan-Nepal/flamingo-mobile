import 'package:flamingo/feature/cart/data/cart_repository.dart';
import 'package:flamingo/feature/cart/data/model/update_cart_request.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class UpdateCartViewModel extends ChangeNotifier {
  final CartRepository _cartRepository;

  UpdateCartViewModel({
    required CartRepository cartRepository,
  }) : _cartRepository = cartRepository;

  Response _updateCartUseCase = Response();
  Response _removeCartUseCase = Response();

  Response get updateCartUseCase => _updateCartUseCase;
  Response get removeCartUseCase => _removeCartUseCase;

  void setUpdateCartUseCase(Response response) {
    _updateCartUseCase = response;
    notifyListeners();
  }

  void setRemoveCartUseCase(Response response) {
    _removeCartUseCase = response;
    notifyListeners();
  }

  Future<void> updateCart(String cartId, int quantity) async {
    try {
      setUpdateCartUseCase(Response.loading());
      final response = await _cartRepository.updateCart(
        cartId,
        UpdateCartRequest(
          quantity: quantity,
        ),
      );
      setUpdateCartUseCase(Response.complete(response));
    } catch (exception) {
      setUpdateCartUseCase(Response.error(exception));
    }
  }

  Future<void> removeFromCart(String cartId) async {
    try {
      setRemoveCartUseCase(Response.loading());
      final response = await _cartRepository.deleteCart(cartId);
      setRemoveCartUseCase(Response.complete(response));
    } catch (exception) {
      setRemoveCartUseCase(Response.error(exception));
    }
  }
}
