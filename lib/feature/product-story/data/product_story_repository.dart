import 'package:flamingo/feature/product-story/data/model/grouped_product_story.dart';

abstract class ProductStoryRepository {
  Future<List<GroupedProductStory>> getLikedVendorStories();
  Future viewStory(String storyId);
}
