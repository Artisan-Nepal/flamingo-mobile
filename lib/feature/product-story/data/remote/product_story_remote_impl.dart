import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/product-story/data/model/grouped_product_story.dart';
import 'package:flamingo/feature/product-story/data/model/product_story.dart';
import 'package:flamingo/feature/product-story/data/remote/product_story_remote.dart';

class ProductStoryRemoteImpl implements ProductStoryRemote {
  final ApiClient _apiClient;

  ProductStoryRemoteImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<List<GroupedProductStory>> getLikedVendorStories() async {
    final apiResponse = await _apiClient.get(ApiUrls.likedVendorStory);
    return GroupedProductStory.fromJsonList(apiResponse.data);
  }

  @override
  Future<List<ProductStory>> getVendorStories(String vendorId) async {
    final url = ApiUrls.vendorStory.replaceFirst(':id', vendorId);
    final apiResponse = await _apiClient.get(url);
    return FetchResponse.fromJson(
      apiResponse.data,
      ProductStory.fromJsonList,
    ).rows;
  }

  @override
  Future viewStory(String storyId) async {
    final url = ApiUrls.viewStory.replaceFirst(':id', storyId);
    await _apiClient.post(url);
  }
}
