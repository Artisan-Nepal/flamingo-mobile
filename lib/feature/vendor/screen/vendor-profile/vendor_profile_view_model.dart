import 'package:flamingo/feature/vendor/data/model/vendor_like_response.dart';
import 'package:flamingo/feature/vendor/data/vendor_repository.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class VendorProfileViewModel extends ChangeNotifier {
  final VendorRepository _vendorRepository;

  VendorProfileViewModel({required VendorRepository vendorRepository})
      : _vendorRepository = vendorRepository;

  Response<VendorLikeResponse> _vendorLikeUseCase =
      Response<VendorLikeResponse>();
  Response<VendorLikeResponse> get vendorLikeUseCase => _vendorLikeUseCase;

  void setVendorLikeUseCase(Response<VendorLikeResponse> response) {
    _vendorLikeUseCase = response;
    notifyListeners();
  }

  Future<void> getVendorLikes(String vendorId) async {
    try {
      setVendorLikeUseCase(Response.loading());
      final response = await _vendorRepository.getVendorLikes(vendorId);
      setVendorLikeUseCase(Response.complete(response));
    } catch (exception) {
      setVendorLikeUseCase(Response.error(exception));
    }
  }
}
