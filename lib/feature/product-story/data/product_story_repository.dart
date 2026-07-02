import 'package:flamingo/feature/product-story/data/model/grouped_product_story.dart';
import 'package:flamingo/feature/product-story/data/model/product_story.dart';

abstract class ProductStoryRepository {
  Future<List<GroupedProductStory>> getLikedVendorStories();
  Future<List<ProductStory>> getVendorStories(String vendorId);
  Future viewStory(String storyId);
}
