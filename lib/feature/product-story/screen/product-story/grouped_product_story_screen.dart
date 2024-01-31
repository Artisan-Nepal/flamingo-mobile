import 'package:flamingo/feature/product-story/data/model/grouped_product_story.dart';
import 'package:flamingo/feature/product-story/screen/product-story/product_story_screen.dart';
import 'package:flutter/material.dart';

class GroupedProductStoriesScreen extends StatelessWidget {
  const GroupedProductStoriesScreen({
    super.key,
    required this.groupedStories,
  });

  final List<GroupedProductStory> groupedStories;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView.builder(
      itemCount: groupedStories.length,
      itemBuilder: (context, index) {
        return ProductStoryScreen(
          stories: groupedStories[index].productStories,
          image: groupedStories[index].productImage,
          title: groupedStories[index].productTitle,
        );
      },
    ));
  }
}
