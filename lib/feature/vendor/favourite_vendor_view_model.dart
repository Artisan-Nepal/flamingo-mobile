import 'package:flamingo/feature/vendor/data/model/vendor.dart';
import 'package:flutter/material.dart';

class FavouriteVendorViewModel extends ChangeNotifier {
  final Map<String, bool> _favouriteVendorStatus = {};

  Map<String, bool> get favouriteVendorStatus => _favouriteVendorStatus;

  initFavouriteVendorStatus(List<Vendor> vendors) {
    final vendorsWishlistStatus =
        vendors.map((vendor) => MapEntry(vendor.id, vendor.isFavourited));
    _favouriteVendorStatus.addEntries(vendorsWishlistStatus);
  }

  addToVisitedVendor(String vendorId, bool isFavourited) {
    _favouriteVendorStatus.addEntries([MapEntry(vendorId, isFavourited)]);
  }

  toggleVisitedVendorFavouriteStatus(String vendorId) {
    bool isFavourited = _favouriteVendorStatus[vendorId] ?? false;
    _favouriteVendorStatus[vendorId] = !isFavourited;
    notifyListeners();
  }

  bool isFavourited(String vendorId) {
    return _favouriteVendorStatus[vendorId] ?? false;
  }
}
