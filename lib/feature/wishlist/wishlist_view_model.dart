import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flutter/material.dart';

class WishlistViewModel extends ChangeNotifier {
  final Map<String, bool> _wishlistStatus = {};

  Map<String, bool> get wishlistStatus => _wishlistStatus;

  initWishlistStatus(List<Product> products) {
    final productsWishlistStatus =
        products.map((product) => MapEntry(product.id, product.isInWishlist));
    _wishlistStatus.addEntries(productsWishlistStatus);
  }

  addToVisitedProductWishList(String productId, bool isInWishList) {
    _wishlistStatus.addEntries([MapEntry(productId, isInWishList)]);
  }

  toggleVisitedProductWishListStatus(String productId) {
    bool isInWishList = _wishlistStatus[productId] ?? false;
    _wishlistStatus[productId] = !isInWishList;
    notifyListeners();
  }

  bool isInWishlist(String productId) {
    return _wishlistStatus[productId] ?? false;
  }
}
