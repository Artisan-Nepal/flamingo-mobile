import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/wishlist/data/model/wishlist_item.dart';
import 'package:flamingo/feature/wishlist/data/wishlist_repository.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/cupertino.dart';

class WishlistListingViewModel extends ChangeNotifier {
  final WishlistRepository _wishlistRepository;

  WishlistListingViewModel({required WishlistRepository wishlistRepository})
      : _wishlistRepository = wishlistRepository;

  Response<FetchResponse<WishlistItem>> _wishlistUseCase =
      Response<FetchResponse<WishlistItem>>();
  Response<FetchResponse<WishlistItem>> get wishlistUseCase => _wishlistUseCase;

  void setWishlistUseCase(Response<FetchResponse<WishlistItem>> response) {
    _wishlistUseCase = response;
    notifyListeners();
  }

  Future<void> getWishlist() async {
    try {
      setWishlistUseCase(Response.loading());
      final response = await _wishlistRepository.getUserWishlist();
      setWishlistUseCase(Response.complete(response));
    } catch (exception) {
      setWishlistUseCase(Response.error(exception));
    }
  }

  void removeFromWishlistState(String productId) {
    wishlistUseCase.data?.rows
        .removeWhere((element) => element.product.id == productId);
    notifyListeners();
  }
}
