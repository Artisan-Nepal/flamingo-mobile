import 'package:flamingo/feature/product-story/data/model/product_story.dart';

abstract class ProductStoryRemote {
  Future<List<ProductStory>> getLikedVendorStories();
  Future viewStory(String storyId);
}
