import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/product/data/model/get_product_request.dart';
import 'package:flamingo/feature/product/data/model/product.dart';

abstract class ProductRepository {
  Future<FetchResponse<Product>> getVendorProducts(String vendorId);
  Future<FetchResponse<Product>> getProducts(GetProductRequest request);
  Future<FetchResponse<Product>> getLatestProducts();
  Future<FetchResponse<Product>> getCategoryProducts(String categoryId);
  Future<Product> getSingleProduct(String productId);
}
