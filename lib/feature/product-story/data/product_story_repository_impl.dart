// ignore_for_file: unused_field

import 'package:flamingo/feature/feature.dart';
import 'package:flamingo/feature/product-story/data/local/product_story_local.dart';
import 'package:flamingo/feature/product-story/data/model/grouped_product_story.dart';
import 'package:flamingo/feature/product-story/data/product_story_repository.dart';
import 'package:flamingo/feature/product-story/data/remote/product_story_remote.dart';

class ProducStoryRepositoryImpl implements ProductStoryRepository {
  final ProductStoryLocal _productStoryLocal;
  final ProductStoryRemote _productStoryRemote;
  final AuthRepository _authRepository;

  ProducStoryRepositoryImpl({
    required ProductStoryLocal productStoryLocal,
    required ProductStoryRemote productStoryRemote,
    required AuthRepository authRepository,
  })  : _productStoryLocal = productStoryLocal,
        _productStoryRemote = productStoryRemote,
        _authRepository = authRepository;

  @override
  Future<List<GroupedProductStory>> getLikedVendorStories() async {
    return await _productStoryRemote.getLikedVendorStories();
  }

  @override
  Future viewStory(String storyId) async {
    return await _productStoryRemote.viewStory(storyId);
  }
}
