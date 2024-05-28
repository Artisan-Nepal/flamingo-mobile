import 'package:flamingo/feature/vendor/data/model/vendor.dart';
import 'package:flamingo/feature/vendor/data/vendor_repository.dart';
import 'package:flamingo/shared/util/util.dart';
import 'package:flutter/material.dart';

class VendorProfileViewModel extends ChangeNotifier {
  // ignore: unused_field
  final VendorRepository _vendorRepository;

  VendorProfileViewModel({required VendorRepository vendorRepository})
      : _vendorRepository = vendorRepository;

  Response<Vendor> _vendorUseCase = Response<Vendor>();
  Response<Vendor> get vendorUseCase => _vendorUseCase;

  void setVendorUseCase(Response<Vendor> response) {
    _vendorUseCase = response;
    notifyListeners();
  }

  Future<void> getVendorBySellerId(String selerId) async {
    try {
      final response = await _vendorRepository.getVendorBySellerId(selerId);
      setVendorUseCase(Response.complete(response));
    } catch (exception) {
      setVendorUseCase(Response.error(exception));
    }
  }
}
