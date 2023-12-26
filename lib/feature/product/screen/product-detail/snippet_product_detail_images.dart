import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/feature/product/screen/product-detail/product_detail_app_bar_view_model.dart';
import 'package:flamingo/feature/product/screen/product-detail/product_detail_images_screen.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/fav-button/fav_button_widget.dart';
import 'package:flamingo/widget/image/cached_network_image_widget.dart';
import 'package:flamingo/widget/space/space.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SnippetProductDetailImages extends StatefulWidget {
  const SnippetProductDetailImages({
    Key? key,
    required this.variants,
    required this.productId,
  }) : super(key: key);

  final List<ProductVariant> variants;
  final String productId;

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
            itemCount: widget.variants.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                NavigationHelper.pushWithoutAnimation(
                  context,
                  ProductDetailImageScreen(
                    variants: widget.variants,
                    selectedIndex: index,
                  ),
                );
              },
              child: CachedNetworkImageWidget(
                image: widget.variants[index].image.url,
                fit: BoxFit.cover,
              ),
            ),
          ),
          _buildIndicator(),
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildIndicator() {
    if (widget.variants.length < 2) return const SizedBox();
    return Positioned(
      bottom: 10,
      child: SmoothPageIndicator(
        controller: _pageController,
        count: widget.variants.length,
        effect: ColorTransitionEffect(
          dotHeight: 2.5,
          dotWidth:
              (SizeConfig.screenWidth - 5 - 2 * Dimens.spacingSizeDefault) /
                  widget.variants.length,
          spacing: 5,
          activeDotColor: AppColors.primaryMain,
        ),
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
                child: FavButtonWidget(productId: widget.productId),
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
