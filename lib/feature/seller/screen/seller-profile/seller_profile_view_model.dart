import 'package:flamingo/feature/seller/data/seller_repository.dart';
import 'package:flamingo/feature/vendor/data/model/seller.dart';
import 'package:flamingo/shared/util/util.dart';
import 'package:flutter/material.dart';

class SellerDetailViewModel extends ChangeNotifier {
  final SellerRepository _sellerRepository;

  SellerDetailViewModel({required SellerRepository sellerRepository})
      : _sellerRepository = sellerRepository;

  Response<Seller> _sellerUseCase = Response<Seller>();
  Response<Seller> get sellerUseCase => _sellerUseCase;

  void setSellerUseCase(Response<Seller> response) {
    _sellerUseCase = response;
    notifyListeners();
  }

  Future<void> getProfile() async {
    try {
      final response = await _sellerRepository.getSeller();
      setSellerUseCase(Response.complete(response));
    } catch (exception) {
      setSellerUseCase(Response.error(exception));
    }
  }
}
