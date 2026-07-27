import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/product/data/model/for_you_section.dart';
import 'package:flamingo/feature/product/data/model/get_product_request.dart';
import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/feature/product/data/model/product_detail.dart';
import 'package:flamingo/feature/product/data/model/variant_measurement.dart';

abstract class ProductRepository {
  Future<FetchResponse<ProductDetail>> getVendorProducts(String vendorId);
  Future<FetchResponse<ProductDetail>> getSellerProducts(String sellerId);
  Future<FetchResponse<ProductDetail>> getProducts(GetProductRequest request);
  Future<FetchResponse<ProductDetail>> getLatestProducts();
  Future<FetchResponse<ProductDetail>> getCategoryProducts(String categoryId);
  Future<List<ForYouSection>> getForYouSections();
  Future<ProductDetail> getSingleProduct(String productId);
  Future<List<Product>> getRelatedProducts(String productId);
  Future<List<Product>> getUserRecommendations();
  Future<List<Product>> getCheaperAlternatives(String productId);
  Future<List<Product>> getInStockAlternatives(String productId);
  Future<List<VariantMeasurement>> getVariantMeasurements(String variantId);
}
