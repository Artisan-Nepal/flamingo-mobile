import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/product/data/model/get_product_request.dart';
import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/feature/product/data/model/product_detail.dart';
import 'package:flamingo/feature/product/data/remote/product_remote.dart';

class ProductRemoteImpl implements ProductRemote {
  final ApiClient _apiClient;

  ProductRemoteImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<FetchResponse<ProductDetail>> getVendorProducts(
      String vendorId) async {
    final url = ApiUrls.productsByVendorId.replaceFirst(':id', vendorId);
    final apiResponse = await _apiClient.get(url);
    return FetchResponse.fromJson(
      apiResponse.data,
      ProductDetail.fromJsonList,
    );
  }

  @override
  Future<FetchResponse<ProductDetail>> getCategoryProducts(
      String categoryId) async {
    final url = ApiUrls.productsByCategoryId.replaceFirst(':id', categoryId);
    final apiResponse = await _apiClient.get(url);
    return FetchResponse.fromJson(
      apiResponse.data,
      ProductDetail.fromJsonList,
    );
  }

  @override
  Future<FetchResponse<ProductDetail>> getProducts(
      GetProductRequest request) async {
    final url = ApiUrls.products;
    final apiResponse =
        await _apiClient.get(url, queryParams: request.toJson());
    return FetchResponse.fromJson(
      apiResponse.data,
      ProductDetail.fromJsonList,
    );
  }

  @override
  Future<ProductDetail> getSingleProduct(String productId) async {
    final url = ApiUrls.products + '/$productId';
    final apiResponse = await _apiClient.get(url);
    return ProductDetail.fromJson(apiResponse.data);
  }

  @override
  Future<FetchResponse<ProductDetail>> getLatestProducts() async {
    final apiResponse = await _apiClient.get(ApiUrls.latestProducts);
    return FetchResponse.fromJson(
      apiResponse.data,
      ProductDetail.fromJsonList,
    );
  }

  @override
  Future<List<Product>> getRelatedProducts(String productId) async {
    final url =
        ApiUrls.getRelatedProducts.replaceFirst(':productId', productId);
    final apiResponse = await _apiClient.get(url);
    return Product.fromJsonList(apiResponse.data);
  }

  @override
  Future<List<Product>> getUserRecommendations(String userId) async {
    final url = ApiUrls.getUserRecommendations.replaceFirst(':userId', userId);
    final apiResponse = await _apiClient.get(url);
    return Product.fromJsonList(apiResponse.data);
  }
}
