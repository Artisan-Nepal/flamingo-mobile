import 'package:flamingo/feature/dashboard/screen/home/snippet_home_products.dart';
import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/feature/product/data/model/product_detail.dart';
import 'package:flamingo/feature/product/screen/product-listing/product_listing_screen.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/product/product.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';

// "Most wanted right now" - the home surface for the backend's weighted
// trending ranking (orders > cart > wishlist > views, see
// ProductService.findTrendingProducts). Renders all ranked products in score
// order; the old "Trending now" rail silently capped display at 6, so a good
// chunk of the ranking never reached the screen.
//
// Rank numerals were tried here and removed by design decision - the ordering
// carries the ranking on its own, and the numerals fought the monochrome look.
class SnippetHomeTrending extends StatelessWidget {
  const SnippetHomeTrending({
    super.key,
    required this.isLoading,
    required this.products,
  });

  final bool isLoading;
  final List<ProductDetail> products;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoader();
    }

    if (products.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SnippetHomeScreenTitle(
          title: 'MOST WANTED RIGHT NOW',
          onTap: () => NavigationHelper.push(
            context,
            const ProductListingScreen(
              title: 'Most wanted right now',
              productType: ProductType.TRENDING,
            ),
          ),
        ),
        Container(
          width: SizeConfig.screenWidth,
          height: SizeConfig.screenHeight * 0.47,
          margin: const EdgeInsets.symmetric(vertical: Dimens.spacingSizeSmall),
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) => Container(
              margin: EdgeInsets.only(
                left: index == 0 ? Dimens.spacingSizeSmall : 0,
                right: Dimens.spacingSizeDefault,
              ),
              width: SizeConfig.screenWidth * 0.6,
              child: ProductWidget(
                imageHeight: SizeConfig.screenHeight * 0.35,
                nameMaxLines: 1,
                payload: Product.fromDetail(products[index]),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.spacingSizeSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: AppColors.grayLighter,
            height: 15,
            width: 200,
          ),
          const VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
          Row(
            children: [
              Container(
                color: AppColors.grayLighter,
                height: SizeConfig.screenHeight * 0.3,
                width: 300,
              ),
              const HorizontalSpaceWidget(width: Dimens.spacingSizeSmall),
              Expanded(
                child: Container(
                  color: AppColors.grayLighter,
                  height: SizeConfig.screenHeight * 0.3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

