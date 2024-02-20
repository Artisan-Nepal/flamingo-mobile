import 'package:flamingo/feature/product-story/product_story_engagement_view_model.dart';
import 'package:flamingo/feature/product-story/product_story_view_model.dart';
import 'package:flamingo/feature/product-story/screen/product-story/grouped_product_story_screen.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/image/image.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SnippetHomeScreenStory extends StatelessWidget {
  const SnippetHomeScreenStory({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductStoryViewModel>(
      builder: (context, viewModel, child) {
        final stories = viewModel.productStoryUseCase.data ?? [];
        if (viewModel.productStoryUseCase.isLoading)
          return Container(
            height: 120,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.grayLighter,
                ),
              ),
            ),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ...List.generate(5, (index) {
                  return Row(
                    children: [
                      HorizontalSpaceWidget(width: Dimens.spacingSizeSmall),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.grayLighter,
                          shape: BoxShape.circle,
                        ),
                        height: 70,
                        width: 70,
                      ),
                    ],
                  );
                })
              ],
            ),
          );

        if (!viewModel.productStoryUseCase.hasCompleted || stories.isEmpty)
          return SizedBox();

        return Consumer<ProductStoryEngagementViewModel>(
          builder: (context, engagementViewModel, child) {
            return Container(
              height: 120,
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
                  final hasViewed = stories[index].items.every(
                        (item) => engagementViewModel.hasViewed(item.story.id),
                      );
                  return Container(
                    width: 90,
                    margin: EdgeInsets.only(
                      left: index == 0 ? Dimens.spacingSizeSmall : 0,
                      right: Dimens.spacingSizeSmall,
                    ),
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            NavigationHelper.push(
                              context,
                              GroupedProductStoriesScreen(
                                groupedStories: stories,
                                index: index,
                              ),
                            );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: hasViewed
                                    ? AppColors.grayLight
                                    : AppColors.black,
                                width: hasViewed ? 1.5 : 2.5,
                              ),
                            ),
                            padding: EdgeInsets.all(2),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImageWidget(
                                image:
                                    stories[index].vendor.displayImage?.url ??
                                        stories[0].items[0].productImage,
                                height: 70,
                                width: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        VerticalSpaceWidget(height: Dimens.spacing_2),
                        Text(
                          stories[index].vendor.storeName,
                          style: textTheme(context).bodySmall,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
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
