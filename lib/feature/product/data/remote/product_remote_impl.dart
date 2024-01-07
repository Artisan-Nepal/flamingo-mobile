import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/feature/product/data/remote/product_remote.dart';

class ProductRemoteImpl implements ProductRemote {
  final ApiClient _apiClient;

  ProductRemoteImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<FetchResponse<Product>> getVendorProducts(String vendorId) async {
    final url = ApiUrls.productsByVendorId.replaceFirst(':id', vendorId);
    final apiResponse = await _apiClient.get(url);
    return FetchResponse.fromJson(
      apiResponse.data,
      Product.fromJsonList,
    );
  }

  @override
  Future<FetchResponse<Product>> getCategoryProducts(String categoryId) async {
    final url = ApiUrls.productsByCategoryId.replaceFirst(':id', categoryId);
    final apiResponse = await _apiClient.get(url);
    return FetchResponse.fromJson(
      apiResponse.data,
      Product.fromJsonList,
    );
  }

  @override
  Future<FetchResponse<Product>> getProducts() async {
    final url = ApiUrls.products;
    final apiResponse = await _apiClient.get(url);
    return FetchResponse.fromJson(
      apiResponse.data,
      Product.fromJsonList,
    );
  }

  @override
  Future<Product> getSingleProduct(String productId) async {
    final url = ApiUrls.products + '/$productId';
    final apiResponse = await _apiClient.get(url);
    return Product.fromJson(apiResponse.data);
  }

  @override
  Future<FetchResponse<Product>> getLatestProducts() async {
    final apiResponse = await _apiClient.get(ApiUrls.latestProducts);
    return FetchResponse.fromJson(
      apiResponse.data,
      Product.fromJsonList,
    );
  }
}
