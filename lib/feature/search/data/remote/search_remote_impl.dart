import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/product/data/model/product_detail.dart';
import 'package:flamingo/feature/search/data/model/search_request.dart';
import 'package:flamingo/feature/search/data/remote/search_remote.dart';

class SearchRemoteImpl implements SearchRemote {
  // ignore: unused_field
  final ApiClient _apiClient;

  SearchRemoteImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<FetchResponse<ProductDetail>> searchProducts(
      SearchRequest request) async {
    final apiResponse =
        await _apiClient.post(ApiUrls.productSearch, body: request.toJson());
    return FetchResponse.fromJson(
      apiResponse.data,
      ProductDetail.fromJsonList,
    );
  }

  @override
  Future<List<String>> getSearchSuggestions(SearchRequest request) async {
    final apiResponse = await _apiClient.post(ApiUrls.productSearchSuggestion,
        body: request.toJson());
    return List<String>.from(apiResponse.data);
  }
}
