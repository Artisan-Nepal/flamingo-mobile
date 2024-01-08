import 'package:flamingo/data/data.dart';
import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/vendor/data/model/vendor.dart';
import 'package:flamingo/feature/vendor/data/vendor_repository.dart';
import 'package:flamingo/feature/vendor/favourite_vendor_view_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class VendorListingViewModel extends ChangeNotifier {
  final VendorRepository _vendorRepository;

  VendorListingViewModel({required VendorRepository vendorRepository})
      : _vendorRepository = vendorRepository;

  Response<FetchResponse<Vendor>> _vendorUseCase =
      Response<FetchResponse<Vendor>>();
  Response<FetchResponse<Vendor>> get vendorUseCase => _vendorUseCase;

  void setVendorUseCase(Response<FetchResponse<Vendor>> response) {
    _vendorUseCase = response;
    notifyListeners();
  }

  Future<void> getVendors() async {
    try {
      setVendorUseCase(Response.loading());
      final response = await _vendorRepository.getVendors();
      locator<FavouriteVendorViewModel>()
          .initFavouriteVendorStatus(response.rows);
      setVendorUseCase(Response.complete(response));
    } catch (exception) {
      setVendorUseCase(Response.error(exception));
    }
  }
}
