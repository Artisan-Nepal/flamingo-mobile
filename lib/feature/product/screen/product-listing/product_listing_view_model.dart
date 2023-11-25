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
  List<Product> _sortedProducts = [];
  ProductFilterType? _selectedFilterType;

  Response<FetchResponse<Product>> get getProductsUseCase =>
      _getProductsUseCase;
  List<Product> get sortedProducts => _sortedProducts;
  ProductFilterType? get selectedFilterType => _selectedFilterType;

  void setSelectedFilterType(ProductFilterType filterType) {
    _selectedFilterType = filterType;
    notifyListeners();
  }

  void setProductsUseCase(Response<FetchResponse<Product>> response) {
    _getProductsUseCase = response;
    if (response.data != null) {
      _sortedProducts = response.data!.rows;
    }
    notifyListeners();
  }

  // Sorting according to filter
  sortProducts({
    double startingPrice = 0,
    double endingPrice = 0,
    ProductFilterType? filterType,
  }) {
    _sortedProducts = sortProductsHelper(
      startingPrice: startingPrice,
      endingPrice: endingPrice,
      products: _getProductsUseCase.data?.rows ?? [],
      filterType: filterType ?? _selectedFilterType,
    );
    notifyListeners();
  }

  // restore the sorted list to original state
  restoreSortedList() {
    _selectedFilterType = null;
    _sortedProducts = _getProductsUseCase.data?.rows ?? [];
    notifyListeners();
  }

  Future<void> getVendorProducts(String vendorId) async {
    try {
      setProductsUseCase(Response.loading());
      final response = await _productRepository.getVendorProducts(vendorId);
      setProductsUseCase(Response.complete(response));
    } catch (exception) {
      setProductsUseCase(Response.error(exception));
    }
  }

  Future<void> getProducts() async {
    try {
      setProductsUseCase(Response.loading());
      final response = await _productRepository.getProducts();
      setProductsUseCase(Response.complete(response));
    } catch (exception) {
      setProductsUseCase(Response.error(exception));
    }
  }

  Future<void> getCategoryProducts(String catgeoryId) async {
    try {
      setProductsUseCase(Response.loading());
      final response = await _productRepository.getCategoryProducts(catgeoryId);
      setProductsUseCase(Response.complete(response));
    } catch (exception) {
      setProductsUseCase(Response.error(exception));
    }
  }
}
