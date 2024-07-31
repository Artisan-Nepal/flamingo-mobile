import 'package:flamingo/data/data.dart';
import 'package:flamingo/data/model/paginated_option.dart';
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

  void appendVendorUseCase(FetchResponse<Vendor> response) {
    _vendorUseCase.data!.rows.addAll(response.rows);
    _vendorUseCase.data!.metadata = response.metadata;
    notifyListeners();
  }

  Future<void> getVendors({
    bool updateState = true,
    bool paginate = false,
    PaginationOption? paginationOption,
  }) async {
    try {
      if (updateState) setVendorUseCase(Response.loading());
      final response = await _vendorRepository.getVendors(paginationOption);
      locator<FavouriteVendorViewModel>()
          .initFavouriteVendorStatus(response.rows);

      if (paginate) {
        appendVendorUseCase(response);
      } else {
        setVendorUseCase(Response.complete(response));
      }
    } catch (exception) {
      if (updateState) setVendorUseCase(Response.error(exception));
    }
  }

  List<Vendor> get favoriteBrands {
    final allVendors = _vendorUseCase.data?.rows ?? [];

    final favBrands = allVendors
        .where((element) =>
            locator<FavouriteVendorViewModel>().isFavourited(element.id))
        .toList();
    if (favBrands.length <= 3) return favBrands;

    return favBrands.sublist(0, 3);
  }

  List<Vendor> get nonFavoriteBrands {
    final allVendors = _vendorUseCase.data?.rows ?? [];

    return allVendors
        .where(
            (element) => !favoriteBrands.map((e) => e.id).contains(element.id))
        .toList();
  }
}
