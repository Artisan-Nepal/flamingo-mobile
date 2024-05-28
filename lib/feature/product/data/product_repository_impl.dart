// ignore_for_file: unused_field

import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/feature.dart';
import 'package:flamingo/feature/product/data/local/product_local.dart';
import 'package:flamingo/feature/product/data/model/get_product_request.dart';
import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/feature/product/data/model/product_detail.dart';
import 'package:flamingo/feature/product/data/product_repository.dart';
import 'package:flamingo/feature/product/data/remote/product_remote.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocal _productLocal;
  final ProductRemote _productRemote;
  final AuthRepository _authRepository;

  ProductRepositoryImpl({
    required ProductLocal productLocal,
    required ProductRemote productRemote,
    required AuthRepository authRepository,
  })  : _productLocal = productLocal,
        _productRemote = productRemote,
        _authRepository = authRepository;

  @override
  Future<FetchResponse<ProductDetail>> getVendorProducts(
      String vendorId) async {
    return await _productRemote.getVendorProducts(vendorId);
  }

  @override
  Future<FetchResponse<ProductDetail>> getSellerProducts(
      String sellerId) async {
    return await _productRemote.getSellerProducts(sellerId);
  }

  @override
  Future<FetchResponse<ProductDetail>> getCategoryProducts(
      String categoryId) async {
    return await _productRemote.getCategoryProducts(categoryId);
  }

  @override
  Future<FetchResponse<ProductDetail>> getProducts(
      GetProductRequest request) async {
    return await _productRemote.getProducts(request);
  }

  @override
  Future<ProductDetail> getSingleProduct(String productId) async {
    return await _productRemote.getSingleProduct(productId);
  }

  @override
  Future<FetchResponse<ProductDetail>> getLatestProducts() async {
    return await _productRemote.getLatestProducts();
  }

  @override
  Future<List<Product>> getRelatedProducts(String productId) async {
    return await _productRemote.getRelatedProducts(productId);
  }

  @override
  Future<List<Product>> getUserRecommendations() async {
    final userId = (await _authRepository.getUserLocal())!.userId;
    return await _productRemote.getUserRecommendations(userId);
  }
}
