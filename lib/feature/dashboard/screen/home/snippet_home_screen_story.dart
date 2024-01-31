import 'package:flamingo/feature/product-story/product_story_engagement_view_model.dart';
import 'package:flamingo/feature/product-story/product_story_view_model.dart';
import 'package:flamingo/feature/product-story/screen/product-story/grouped_product_story_screen.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/image/image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SnippetHomeScreenStory extends StatelessWidget {
  const SnippetHomeScreenStory({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductStoryViewModel>(
      builder: (context, viewModel, child) {
        final stories = viewModel.productStoryUseCase.data ?? [];
        if (viewModel.productStoryUseCase.isLoading) return Text('Loadng..');

        if (!viewModel.productStoryUseCase.hasCompleted || stories.isEmpty)
          return SizedBox();

        return Consumer<ProductStoryEngagementViewModel>(
          builder: (context, engagementViewModel, child) {
            return Container(
              height: 100,
              width: double.infinity,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: Dimens.spacingSizeSmall),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.grayLighter,
                  ),
                ),
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: stories.length,
                itemBuilder: (context, index) {
                  final hasViewed = stories[index].productStories.every(
                        (story) => engagementViewModel.hasViewed(story.id),
                      );
                  return GestureDetector(
                    onTap: () {
                      NavigationHelper.push(
                        context,
                        GroupedProductStoriesScreen(
                          groupedStories: stories,
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                        left: index == 0 ? Dimens.spacingSizeSmall : 0,
                        right: Dimens.spacingSizeSmall,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              hasViewed ? AppColors.grayLight : AppColors.black,
                          width: hasViewed ? 1.5 : 2.5,
                        ),
                      ),
                      padding: EdgeInsets.all(2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CachedNetworkImageWidget(
                          image: stories[index].productImage,
                          height: 70,
                          width: 70,
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
