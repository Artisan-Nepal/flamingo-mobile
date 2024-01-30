import 'package:flamingo/feature/product/data/model/product_story.dart';
import 'package:flamingo/feature/product/screen/product-detail/product_detail_app_bar_view_model.dart';
import 'package:flamingo/feature/product/screen/product-detail/product_detail_images_screen.dart';
import 'package:flamingo/feature/product/screen/product-detail/product_story_screen.dart';
import 'package:flamingo/shared/enum/lead_source.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/button/variants/outlined_button_widget.dart';
import 'package:flamingo/widget/fav-button/fav_product_button_widget.dart';
import 'package:flamingo/widget/image/cached_network_image_widget.dart';
import 'package:flamingo/widget/space/space.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SnippetProductDetailImages extends StatefulWidget {
  const SnippetProductDetailImages({
    Key? key,
    required this.images,
    required this.productId,
    required this.stories,
    this.leadSource,
    this.advertisementId,
    required this.title,
  }) : super(key: key);

  final List<String> images;
  final String productId;
  final LeadSource? leadSource;
  final String? advertisementId;
  final List<ProductStory> stories;
  final String title;

  @override
  State<SnippetProductDetailImages> createState() =>
      _SnippetProductDetailImagesState();
}

class _SnippetProductDetailImagesState
    extends State<SnippetProductDetailImages> {
  late PageController _pageController;
  @override
  void initState() {
    _pageController = PageController(viewportFraction: 0.99999999);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: SizeConfig.screenHeight * 0.5,
      ),
      // height: 200,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                NavigationHelper.pushWithoutAnimation(
                  context,
                  ProductDetailImageScreen(
                    images: widget.images,
                    selectedIndex: index,
                  ),
                );
              },
              child: CachedNetworkImageWidget(
                image: widget.images[index],
                fit: BoxFit.cover,
              ),
            ),
          ),
          _buildIndicator(),
          _buildActions(),
          _buildStoryButton(),
        ],
      ),
    );
  }

  Widget _buildIndicator() {
    if (widget.images.length < 2) return const SizedBox();
    return Positioned(
      bottom: 10,
      child: SmoothPageIndicator(
        controller: _pageController,
        count: widget.images.length,
        effect: ColorTransitionEffect(
          dotHeight: 2.5,
          dotWidth:
              (SizeConfig.screenWidth - 5 - 2 * Dimens.spacingSizeDefault) /
                  widget.images.length,
          spacing: 5,
          activeDotColor: AppColors.primaryMain,
        ),
      ),
    );
  }

  Widget _buildStoryButton() {
    if (widget.stories.isEmpty) return const SizedBox();
    return Positioned(
      right: 10,
      bottom: 20,
      child: OutlinedButtonWidget(
        label: 'View stories',
        width: 130,
        onPressed: () {
          NavigationHelper.push(
            context,
            ProductStoryScreen(
              stories: widget.stories,
              image: widget.images.firstOrNull ?? "",
              title: widget.title,
            ),
          );
        },
      ),
    );
  }

  Widget _buildActions() {
    return Consumer<ProductDetailAppBarViewModel>(
      builder: (context, appbarViewModel, child) {
        double favIconOpacity = 1 - (appbarViewModel.productDetailsOffset / 20);
        double shareIconOpacity =
            1 - (appbarViewModel.productDetailsOffset / 70);

        favIconOpacity = favIconOpacity.clamp(0, 1);
        shareIconOpacity = shareIconOpacity.clamp(0, 1);
        return Positioned(
          right: Dimens.spacingSizeDefault,
          top: 56 + Dimens.spacingSizeSmall,
          child: Column(
            children: [
              Opacity(
                opacity: favIconOpacity,
                child: FavProductButtonWidget(
                  productId: widget.productId,
                  advertisementId: widget.advertisementId,
                  leadSource: widget.leadSource,
                ),
              ),
              const VerticalSpaceWidget(height: Dimens.spacingSizeLarge),
              Opacity(
                opacity: shareIconOpacity,
                child: GestureDetector(
                  onTap: () {},
                  child: const Icon(
                    CupertinoIcons.share,
                    size: Dimens.iconSize_22,
                    // color: iconColor,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
