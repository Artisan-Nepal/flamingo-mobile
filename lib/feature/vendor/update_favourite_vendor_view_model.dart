import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/vendor/data/model/update_favourite_vendor_request.dart';
import 'package:flamingo/feature/vendor/data/vendor_repository.dart';
import 'package:flamingo/feature/vendor/favourite_vendor_view_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class UpdateFavouriteVendorViewModel extends ChangeNotifier {
  final VendorRepository _vendorRepository;

  UpdateFavouriteVendorViewModel({
    required VendorRepository vendorRepository,
  }) : _vendorRepository = vendorRepository;

  Response _updateFavouriteVendorUseCase = Response();

  Response get updateFavouriteVendorUseCase => _updateFavouriteVendorUseCase;

  void setUpdateFavouriteVendorUseCase(Response response) {
    _updateFavouriteVendorUseCase = response;
    notifyListeners();
  }

  Future<void> updateFavouriteVendor(String vendorId) async {
    try {
      setUpdateFavouriteVendorUseCase(Response.loading());
      locator<FavouriteVendorViewModel>()
          .toggleVisitedVendorFavouriteStatus(vendorId);
      final response = await _vendorRepository.updateFavouriteVendor(
        UpdateFavouriteVendorRequest(
          vendorId: vendorId,
        ),
      );
      setUpdateFavouriteVendorUseCase(Response.complete(response));
    } catch (exception) {
      locator<FavouriteVendorViewModel>()
          .toggleVisitedVendorFavouriteStatus(vendorId);
      setUpdateFavouriteVendorUseCase(Response.error(exception));
    }
  }
}
