import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/product-story/data/model/product_story.dart';
import 'package:flamingo/feature/product-story/product_story_view_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/image/cached_network_image_widget.dart';
import 'package:flamingo/widget/video-view/video_view_widget.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductStoryScreen extends StatefulWidget {
  const ProductStoryScreen({
    super.key,
    required this.stories,
    required this.image,
    required this.title,
  });

  final List<ProductStory> stories;
  final String image;
  final String title;

  @override
  State<ProductStoryScreen> createState() => _ProductStoryScreenState();
}

class _ProductStoryScreenState extends State<ProductStoryScreen> {
  late PageController _pageController;
  late int _index = 0;

  setIndex(int value) {
    _index = value;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _index = widget.stories.indexWhere((s) => !s.hasViewed);
    _pageController = PageController(initialPage: _index);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
      child: Scaffold(
        backgroundColor: AppColors.black,
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: GestureDetector(
                  // onTapUp: onTapUp,
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    children: List.generate(widget.stories.length, (index) {
                      return ProductStoryItem(story: widget.stories[index]);
                    }),
                  ),
                ),
              ),
              _buildStoryHeader(),
              _buildStoryChangeButtons(),
            ],
          ),
        ),
      ),
    );
  }

  // void onTapUp(TapUpDetails details) {
  //   bool isLeftTap = details.globalPosition.dx < SizeConfig.screenWidth / 2;

  //   if (isLeftTap) {
  //     if (_index > 0) {
  //       _index--;
  //       _pageController.jumpToPage(_index);
  //     }
  //   } else {
  //     if (_index < widget.stories.length - 1) {
  //       _index++;
  //       _pageController.jumpToPage(_index);
  //     }
  //   }
  // }

  Widget _buildStoryChangeButtons() {
    return Positioned(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: Dimens.spacingSizeSmall),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          SizedBox(
            child: _index > 0
                ? GestureDetector(
                    onTap: () {
                      setIndex(_index - 1);
                      _pageController.jumpToPage(_index);
                    },
                    child: Container(
                      padding: EdgeInsets.all(Dimens.spacing_2),
                      decoration: BoxDecoration(
                          color: AppColors.white, shape: BoxShape.circle),
                      child: Icon(Icons.chevron_left),
                    ),
                  )
                : SizedBox(),
          ),
          SizedBox(
            child: _index < widget.stories.length - 1
                ? GestureDetector(
                    onTap: () {
                      setIndex(_index + 1);
                      _pageController.jumpToPage(_index);
                    },
                    child: Container(
                      padding: EdgeInsets.all(Dimens.spacing_2),
                      decoration: BoxDecoration(
                          color: AppColors.white, shape: BoxShape.circle),
                      child: Icon(Icons.chevron_right),
                    ),
                  )
                : SizedBox(),
          ),
        ]),
      ),
    );
  }

  Widget _buildStoryHeader() {
    return Positioned(
      top: Dimens.spacingSizeSmall,
      right: Dimens.spacingSizeSmall,
      left: Dimens.spacingSizeSmall,
      child: Column(
        children: [
          if (widget.stories.length > 1) ...[
            SmoothPageIndicator(
              controller: _pageController,
              count: widget.stories.length,
              effect: ColorTransitionEffect(
                dotHeight: 2.5,
                dotWidth: (SizeConfig.screenWidth -
                        5 -
                        2 * Dimens.spacingSizeDefault) /
                    widget.stories.length,
                spacing: 5,
                activeDotColor: AppColors.white,
                dotColor: AppColors.grayDark,
              ),
            ),
            VerticalSpaceWidget(height: Dimens.spacingSizeSmall),
          ],
          Row(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImageWidget(
                        image: widget.image,
                        height: 35,
                        width: 35,
                      ),
                    ),
                    HorizontalSpaceWidget(width: Dimens.spacingSizeSmall),
                    Expanded(
                      child: Padding(
                        padding:
                            EdgeInsets.only(top: Dimens.spacingSizeExtraSmall),
                        child: Text(
                          widget.title,
                          style: TypographyStyles.bodyMedium.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              HorizontalSpaceWidget(width: Dimens.spacingSizeSmall),
              GestureDetector(
                onTap: () {
                  NavigationHelper.pop(context);
                },
                child: Icon(
                  Icons.close,
                  color: AppColors.white,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class ProductStoryItem extends StatefulWidget {
  const ProductStoryItem({
    super.key,
    required this.story,
  });

  final ProductStory story;

  @override
  State<ProductStoryItem> createState() => _ProductStoryItemState();
}

class _ProductStoryItemState extends State<ProductStoryItem> {
  final _viewModel = locator<ProductStoryViewModel>();

  @override
  void initState() {
    super.initState();
    _viewModel.viewStory(widget.story.id);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _viewModel,
      child: VideoViewWidget(url: widget.story.url),
    );
  }
}
