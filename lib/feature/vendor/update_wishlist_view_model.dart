import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/customer-activity/customer_activity_view_model.dart';
import 'package:flamingo/feature/wishlist/data/model/add_to_wishlist_request.dart';
import 'package:flamingo/feature/wishlist/data/wishlist_repository.dart';
import 'package:flamingo/feature/wishlist/wishlist_view_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class UpdateWishlistViewModel extends ChangeNotifier {
  final VendorRepository _wishlistRepository;

  UpdateWishlistViewModel({
    required VendorRepository wishlistRepository,
  }) : _wishlistRepository = wishlistRepository;

  Response _updateWishlistUseCase = Response();

  Response get updateWishlistUseCase => _updateWishlistUseCase;

  void setUpdateWishlistUseCase(Response response) {
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
      locator<CustomerActivityViewModel>().getCustomerCountInfo();
      setUpdateWishlistUseCase(Response.complete(response));
    } catch (exception) {
      locator<WishlistViewModel>()
          .toggleVisitedProductWishListStatus(productId);
      setUpdateWishlistUseCase(Response.error(exception));
    }
  }
}
