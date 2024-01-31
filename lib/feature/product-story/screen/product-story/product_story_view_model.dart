import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/product-story/data/model/grouped_product_story.dart';
import 'package:flamingo/feature/product-story/data/product_story_repository.dart';
import 'package:flamingo/feature/product-story/product_story_engagement_view_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class ProductStoryViewModel extends ChangeNotifier {
  final ProductStoryRepository _productStoryRepository;

  ProductStoryViewModel({
    required ProductStoryRepository productStoryRepository,
  }) : _productStoryRepository = productStoryRepository;

  Response _viewStoryUseCase = Response();
  Response<List<GroupedProductStory>> _productStoryUseCase =
      Response<List<GroupedProductStory>>();

  Response<List<GroupedProductStory>> get productStoryUseCase =>
      _productStoryUseCase;

  Response get viewStoryUseCase => _viewStoryUseCase;

  void setViewStoryUseCase(Response response) {
    _viewStoryUseCase = response;
    notifyListeners();
  }

  void setProductStoryUseCase(Response<List<GroupedProductStory>> response) {
    _productStoryUseCase = response;
    notifyListeners();
  }

  Future<void> getLikedVendorStories() async {
    try {
      setProductStoryUseCase(Response.loading());
      final response = await _productStoryRepository.getLikedVendorStories();
      setProductStoryUseCase(Response.complete(response));
    } catch (exception) {
      setProductStoryUseCase(Response.error(exception));
    }
  }

  Future<void> viewStory(String storyId) async {
    try {
      final response = await _productStoryRepository.viewStory(storyId);
      locator<ProductStoryEngagementViewModel>().setViewedStatus(storyId);
      setViewStoryUseCase(Response.complete(response));
    } catch (exception) {
      setViewStoryUseCase(Response.error(exception));
    }
  }
}
