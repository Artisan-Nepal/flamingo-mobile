import 'package:flamingo/data/local/local.dart';
import 'package:flamingo/feature/product-story/data/local/product_story_local.dart';

class ProductStoryLocalImpl implements ProductStoryLocal {
  // ignore: unused_field
  final LocalStorageClient _sharedPrefManager;

  ProductStoryLocalImpl({required LocalStorageClient sharedPrefManager})
      : _sharedPrefManager = sharedPrefManager;
}
