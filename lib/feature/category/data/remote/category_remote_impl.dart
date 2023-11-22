import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/category/data/model/product_category.dart';
import 'package:flamingo/feature/category/data/remote/category_remote.dart';

class CategoryRemoteImpl implements CategoryRemote {
  final ApiClient _apiClient;

  CategoryRemoteImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<List<ProductCategory>> getCategoriesByParentId(String parentId) async {
    return [];
  }

  @override
  Future<FetchResponse<ProductCategory>> getAllCategories() async {
    final apiResponse = await _apiClient.get(ApiUrls.categories);
    return FetchResponse.fromJson(
      apiResponse.data,
      ProductCategory.fromJsonList,
    );
  }
}
