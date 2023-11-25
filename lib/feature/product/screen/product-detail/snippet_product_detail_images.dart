import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/feature/product/screen/product-detail/product_detail_images_screen.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/image/cached_network_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SnippetProductDetailImages extends StatefulWidget {
  const SnippetProductDetailImages({
    Key? key,
    required this.variants,
  }) : super(key: key);

  final List<ProductVariant> variants;

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
              child: Hero(
                tag: widget.variants[index].image.id,
                child: CachedNetworkImageWidget(
                  image: widget.variants[index].image.url,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          if (widget.variants.length > 1)
            Positioned(
              bottom: 10,
              child: SmoothPageIndicator(
                controller: _pageController,
                count: widget.variants.length,
                effect: ColorTransitionEffect(
                  dotHeight: 2.5,
                  dotWidth: (SizeConfig.screenWidth -
                          5 -
                          2 * Dimens.spacingSizeDefault) /
                      widget.variants.length,
                  spacing: 5,
                  activeDotColor: AppColors.primaryMain,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Widget _buildIndicator(){
  //   return Row(

  //   ),
  // }
}