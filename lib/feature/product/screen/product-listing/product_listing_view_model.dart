import 'package:flamingo/data/data.dart';
import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/product/data/model/get_product_request.dart';
import 'package:flamingo/feature/product/data/model/product_detail.dart';
import 'package:flamingo/feature/product/data/product_repository.dart';
import 'package:flamingo/feature/wishlist/wishlist_view_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class ProductListingViewModel extends ChangeNotifier {
  final ProductRepository _productRepository;

  ProductListingViewModel({
    required ProductRepository productRepository,
  }) : _productRepository = productRepository;

  Response<FetchResponse<ProductDetail>> _getProductsUseCase =
      Response<FetchResponse<ProductDetail>>();
  List<ProductDetail> _sortedProducts = [];
  ProductFilterType? _selectedFilterType;

  Response<FetchResponse<ProductDetail>> get getProductsUseCase =>
      _getProductsUseCase;
  List<ProductDetail> get sortedProducts => _sortedProducts;
  ProductFilterType? get selectedFilterType => _selectedFilterType;

  void setSelectedFilterType(ProductFilterType filterType) {
    _selectedFilterType = filterType;
    notifyListeners();
  }

  void setProductsUseCase(Response<FetchResponse<ProductDetail>> response) {
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

  Future<void> getVendorProducts(String vendorId,
      {bool isRefresh = false}) async {
    try {
      if (!isRefresh) setProductsUseCase(Response.loading());
      final response = await _productRepository.getVendorProducts(vendorId);
      locator<WishlistViewModel>().initWishlistStatus(response.rows);
      setProductsUseCase(Response.complete(response));
    } catch (exception) {
      if (!isRefresh) setProductsUseCase(Response.error(exception));
    }
  }

  Future<void> getSellerProducts(String sellerId,
      {bool isRefresh = false}) async {
    try {
      if (!isRefresh) setProductsUseCase(Response.loading());
      final response = await _productRepository.getSellerProducts(sellerId);
      locator<WishlistViewModel>().initWishlistStatus(response.rows);
      setProductsUseCase(Response.complete(response));
    } catch (exception) {
      if (!isRefresh) setProductsUseCase(Response.error(exception));
    }
  }

  Future<void> getProducts({
    ProductType? productType,
    bool isRefresh = false,
  }) async {
    try {
      if (!isRefresh) setProductsUseCase(Response.loading());
      final response = await _productRepository
          .getProducts(GetProductRequest(productType: productType));
      locator<WishlistViewModel>().initWishlistStatus(response.rows);
      setProductsUseCase(Response.complete(response));
    } catch (exception) {
      if (!isRefresh) setProductsUseCase(Response.error(exception));
    }
  }

  Future<void> getCategoryProducts(String catgeoryId,
      {bool isRefresh = false}) async {
    try {
      if (!isRefresh) setProductsUseCase(Response.loading());
      final response = await _productRepository.getCategoryProducts(catgeoryId);
      locator<WishlistViewModel>().initWishlistStatus(response.rows);
      setProductsUseCase(Response.complete(response));
    } catch (exception) {
      if (!isRefresh) setProductsUseCase(Response.error(exception));
    }
  }
}
