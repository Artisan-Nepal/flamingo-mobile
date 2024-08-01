import 'package:flamingo/data/data.dart';
import 'package:flamingo/data/model/paginated_option.dart';
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

  void appendCartUseCase(FetchResponse<CartItem> response) {
    _cartUseCase.data!.rows.addAll(response.rows);
    _cartUseCase.data!.metadata = response.metadata;
    notifyListeners();
  }

  Future<void> getCart({
    bool updateState = true,
    bool paginate = false,
    PaginationOption? paginationOption,
  }) async {
    try {
      if (updateState) setCartUseCase(Response.loading());
      final response = await _cartRepository.getUserCart(paginationOption);

      if (paginate) {
        appendCartUseCase(response);
      } else {
        setCartUseCase(Response.complete(response));
      }
    } catch (exception) {
      if (updateState) setCartUseCase(Response.error(exception));
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

  int get cartTotal {
    int price = 0;
    for (CartItem cart in _cartUseCase.data?.rows ?? []) {
      price = price + (cart.productVariant.price * cart.quantity);
    }
    return price;
  }
}
