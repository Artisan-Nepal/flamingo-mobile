import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/feature/product/data/product_repository.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class MinProductListingViewModel extends ChangeNotifier {
  final ProductRepository _productRepository;

  MinProductListingViewModel({
    required ProductRepository productRepository,
  }) : _productRepository = productRepository;

  Response<List<Product>> _getProductsUseCase = Response<List<Product>>();

  Response<List<Product>> get getProductsUseCase => _getProductsUseCase;

  void setProductsUseCase(Response<List<Product>> response) {
    _getProductsUseCase = response;
    notifyListeners();
  }

  Future<void> getUserRecommendation({
    bool isRefresh = false,
  }) async {
    try {
      if (!isRefresh) setProductsUseCase(Response.loading());
      final response = await _productRepository.getUserRecommendations();
      setProductsUseCase(Response.complete(response));
    } catch (exception) {
      if (!isRefresh) setProductsUseCase(Response.error(exception));
    }
  }

  Future<void> getRelatedProducts(
    String productId, {
    bool isRefresh = false,
  }) async {
    try {
      if (!isRefresh) setProductsUseCase(Response.loading());
      final response = await _productRepository.getRelatedProducts(productId);
      setProductsUseCase(Response.complete(response));
    } catch (exception) {
      if (!isRefresh) setProductsUseCase(Response.error(exception));
    }
  }
}
