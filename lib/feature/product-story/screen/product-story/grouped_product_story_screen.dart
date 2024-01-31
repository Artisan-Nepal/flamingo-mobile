import 'package:flamingo/feature/product-story/data/model/grouped_product_story.dart';
import 'package:flamingo/feature/product-story/screen/product-story/product_story_screen.dart';
import 'package:flamingo/shared/util/util.dart';
import 'package:flutter/material.dart';

class GroupedProductStoriesScreen extends StatefulWidget {
  const GroupedProductStoriesScreen({
    super.key,
    required this.groupedStories,
    this.index = 0,
  });

  final List<GroupedProductStory> groupedStories;
  final int index;

  @override
  State<GroupedProductStoriesScreen> createState() =>
      _GroupedProductStoriesScreenState();
}

class _GroupedProductStoriesScreenState
    extends State<GroupedProductStoriesScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.black,
        body: PageView.builder(
          controller: _pageController,
          itemCount: widget.groupedStories.length,
          itemBuilder: (context, index) {
            return ProductStoryScreen(
              stories: widget.groupedStories[index].productStories,
              image: widget.groupedStories[index].productImage,
              title: widget.groupedStories[index].productTitle,
            );
          },
        ));
  }
}
