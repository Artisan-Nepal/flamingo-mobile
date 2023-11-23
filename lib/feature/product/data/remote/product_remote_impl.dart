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
}
