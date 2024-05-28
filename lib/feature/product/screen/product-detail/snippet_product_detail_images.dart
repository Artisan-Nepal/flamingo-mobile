import 'package:flamingo/feature/product-story/data/model/grouped_product_story.dart';
import 'package:flamingo/feature/product-story/data/model/product_story.dart';
import 'package:flamingo/feature/product/screen/product-detail/product_detail_app_bar_view_model.dart';
import 'package:flamingo/feature/product/screen/product-detail/product_detail_images_screen.dart';
import 'package:flamingo/feature/product-story/screen/product-story/product_story_screen.dart';
import 'package:flamingo/feature/vendor/data/model/seller.dart';
import 'package:flamingo/shared/enum/lead_source.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/button/button.dart';
import 'package:flamingo/widget/fav-button/fav_product_button_widget.dart';
import 'package:flamingo/widget/image/cached_network_image_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:share_plus/share_plus.dart';

class SnippetProductDetailImages extends StatefulWidget {
  const SnippetProductDetailImages({
    Key? key,
    required this.images,
    required this.productId,
    required this.stories,
    this.leadSource,
    this.advertisementId,
    required this.title,
    required this.seller,
  }) : super(key: key);

  final List<String> images;
  final String productId;
  final LeadSource? leadSource;
  final String? advertisementId;
  final List<ProductStory> stories;
  final String title;
  final Seller seller;

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
      bottom: widget.images.length > 1 ? 20 : 10,
      child: ButtonWidget(
        backgroundColor: AppColors.white,
        height: 40,
        textColor: AppColors.black,
        padding: EdgeInsets.symmetric(
          horizontal: Dimens.spacingSizeSmall,
          vertical: Dimens.spacingSizeExtraSmall,
        ),
        label: 'View stories',
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'View Stories',
              style: TypographyStyles.bodySmall,
            ),
            Icon(
              Icons.chevron_right,
              size: Dimens.iconSizeSmall,
            ),
          ],
        ),
        width: 130,
        onPressed: () {
          NavigationHelper.push(
            context,
            ProductStoryScreen(
              groupedStory: GroupedProductStory(
                seller: widget.seller,
                items: widget.stories
                    .map((s) => GroupedProductStoryItem(
                        productId: widget.productId,
                        productImage: widget.images.first,
                        productName: widget.title,
                        story: s))
                    .toList(),
              ),
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
          right: 0,
          top: SizeConfig.appBarHeight + SizeConfig.statusBarHeight - 20,
          child: Column(
            children: [
              Opacity(
                opacity: favIconOpacity,
                child: FavProductButtonWidget(
                  productId: widget.productId,
                  advertisementId: widget.advertisementId,
                  leadSource: widget.leadSource,
                  padding: EdgeInsets.only(
                      top: Dimens.spacingSizeSmall,
                      bottom: Dimens.spacingSizeLarge / 2,
                      right: Dimens.spacingSizeDefault),
                ),
              ),
              Opacity(
                opacity: shareIconOpacity,
                child: GestureDetector(
                  onTap: () {
                    Share.share(widget.title);
                  },
                  child: Container(
                    color: AppColors.transparent,
                    padding: EdgeInsets.only(
                        top: Dimens.spacingSizeLarge / 2,
                        bottom: Dimens.spacingSizeExtraSmall,
                        right: Dimens.spacingSizeDefault),
                    child: const Icon(
                      CupertinoIcons.share,
                      size: Dimens.iconSize_22,
                      // color: iconColor,
                    ),
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
