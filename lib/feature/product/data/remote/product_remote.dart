import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/product/data/model/get_product_request.dart';
import 'package:flamingo/feature/product/data/model/product_detail.dart';

abstract class ProductRemote {
  Future<FetchResponse<ProductDetail>> getVendorProducts(String vendorId);
  Future<FetchResponse<ProductDetail>> getProducts(GetProductRequest request);
  Future<FetchResponse<ProductDetail>> getLatestProducts();
  Future<FetchResponse<ProductDetail>> getCategoryProducts(String categoryId);
  Future<ProductDetail> getSingleProduct(String productId);
}
