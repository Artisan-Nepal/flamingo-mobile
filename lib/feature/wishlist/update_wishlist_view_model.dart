import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/wishlist/data/model/add_to_wishlist_request.dart';
import 'package:flamingo/feature/wishlist/data/model/wishlist_item.dart';
import 'package:flamingo/feature/wishlist/data/wishlist_repository.dart';
import 'package:flamingo/feature/wishlist/wishlist_view_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class UpdateWishlistViewModel extends ChangeNotifier {
  final WishlistRepository _wishlistRepository;

  UpdateWishlistViewModel({
    required WishlistRepository wishlistRepository,
  }) : _wishlistRepository = wishlistRepository;

  Response<WishlistItem> _updateWishlistUseCase = Response<WishlistItem>();

  Response<WishlistItem> get updateWishlistUseCase => _updateWishlistUseCase;

  void setUpdateWishlistUseCase(Response<WishlistItem> response) {
    _updateWishlistUseCase = response;
    notifyListeners();
  }

  Future<void> updateWishlist(String productId) async {
    try {
      setUpdateWishlistUseCase(Response.loading());
      locator<WishlistViewModel>()
          .toggleVisitedProductWishListStatus(productId);
      final response = await _wishlistRepository.updateWishlist(
        UpdateWishlistRequest(
          productId: productId,
        ),
      );
      setUpdateWishlistUseCase(Response.complete(response));
    } catch (exception) {
      locator<WishlistViewModel>()
          .toggleVisitedProductWishListStatus(productId);
      setUpdateWishlistUseCase(Response.error(exception));
    }
  }
}
