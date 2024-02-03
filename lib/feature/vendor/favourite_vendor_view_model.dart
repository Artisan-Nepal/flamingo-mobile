import 'package:flamingo/feature/vendor/data/model/vendor.dart';
import 'package:flamingo/feature/vendor/data/vendor_repository.dart';
import 'package:flutter/material.dart';

class FavouriteVendorViewModel extends ChangeNotifier {
  final VendorRepository _vendorRepository;

  FavouriteVendorViewModel({required VendorRepository vendorRepository})
      : _vendorRepository = vendorRepository;

  final Map<String, bool> _favouriteVendorStatus = {};
  final Map<String, int> _vendorLikeCount = {};

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

  int getVendorLikeCount(String vendorId) {
    return _vendorLikeCount[vendorId] ?? 0;
  }

  Future<void> getVendorLikes(String vendorId) async {
    try {
      final response = await _vendorRepository.getVendorLikes(vendorId);
      _vendorLikeCount[vendorId] = response.count;
      notifyListeners();
    } catch (exception) {}
  }
}
