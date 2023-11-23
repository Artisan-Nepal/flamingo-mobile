import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/feature/product/data/product_repository.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class ProductListingViewModel extends ChangeNotifier {
  final ProductRepository _productRepository;

  ProductListingViewModel({
    required ProductRepository productRepository,
  }) : _productRepository = productRepository;

  Response<FetchResponse<Product>> _getProductsUseCase =
      Response<FetchResponse<Product>>();

  Response<FetchResponse<Product>> get getProductsUseCase =>
      _getProductsUseCase;

  void setProductsUseCase(Response<FetchResponse<Product>> response) {
    _getProductsUseCase = response;
    notifyListeners();
  }

  Future<void> getProducts(String vendorId) async {
    try {
      setProductsUseCase(Response.loading());
      final response = await _productRepository.getVendorProducts(vendorId);
      setProductsUseCase(Response.complete(response));
    } catch (exception) {
      setProductsUseCase(Response.error(exception));
    }
  }
}
