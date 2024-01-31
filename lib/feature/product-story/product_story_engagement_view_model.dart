import 'package:flamingo/feature/product-story/data/model/product_story.dart';
import 'package:flutter/material.dart';

class ProductStoryEngagementViewModel extends ChangeNotifier {
  final Map<String, bool> _viewStatus = {};

  Map<String, bool> get viewStatus => _viewStatus;

  initViewStatus(List<ProductStory> stories) {
    final storyViewStatus =
        stories.map((story) => MapEntry(story.id, story.hasViewed));
    _viewStatus.addEntries(storyViewStatus);
  }

  setViewedStatus(String storyId) {
    _viewStatus[storyId] = true;
    notifyListeners();
  }

  bool hasViewed(String storyId) {
    return _viewStatus[storyId] ?? false;
  }
}
