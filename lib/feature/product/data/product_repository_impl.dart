// ignore_for_file: unused_field

import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/feature.dart';
import 'package:flamingo/feature/product/data/local/product_local.dart';
import 'package:flamingo/feature/product/data/model/product.dart';
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
  Future<FetchResponse<Product>> getVendorProducts(String vendorId) async {
    return await _productRemote.getVendorProducts(vendorId);
  }

  @override
  Future<FetchResponse<Product>> getCategoryProducts(String categoryId) async {
    return await _productRemote.getCategoryProducts(categoryId);
  }

  @override
  Future<FetchResponse<Product>> getProducts() async {
    return await _productRemote.getProducts();
  }
}
