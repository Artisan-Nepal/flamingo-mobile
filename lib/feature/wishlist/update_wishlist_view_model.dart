import 'package:flamingo/feature/wishlist/data/model/add_to_wishlist_request.dart';
import 'package:flamingo/feature/wishlist/data/model/wishlist_item.dart';
import 'package:flamingo/feature/wishlist/data/wishlist_repository.dart';
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

  Future<void> updateWishlist(String producId) async {
    try {
      setUpdateWishlistUseCase(Response.loading());
      final response = await _wishlistRepository.updateWishlist(
        UpdateWishlistRequest(
          productId: producId,
        ),
      );
      setUpdateWishlistUseCase(Response.complete(response));
    } catch (exception) {
      setUpdateWishlistUseCase(Response.error(exception));
    }
  }
}
