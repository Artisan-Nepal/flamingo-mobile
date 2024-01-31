import 'package:flamingo/feature/product-story/data/model/grouped_product_story.dart';

abstract class ProductStoryRemote {
  Future<List<GroupedProductStory>> getLikedVendorStories();
  Future viewStory(String storyId);
}
