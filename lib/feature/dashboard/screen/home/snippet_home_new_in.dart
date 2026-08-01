import 'package:flamingo/feature/dashboard/screen/home/snippet_home_products.dart';
import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/feature/product/data/model/product_detail.dart';
import 'package:flamingo/feature/product/screen/product-listing/product_listing_screen.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/product/product.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';

// Replaces the old "Latest" rail with a differently-named, differently-copied
// header over the same product-card size used by every other home rail
// (Most wanted, etc.) - a smaller/compact card was tried here and reverted by
// design decision (2026-07-27): consistent card sizing across rails read
// better than a size cue for "this one is lighter-weight".
class SnippetHomeNewIn extends StatelessWidget {
  const SnippetHomeNewIn({
    super.key,
    required this.isLoading,
    required this.products,
  });

  // Display cap keeps the rail finite and scannable.
  static const int _maxDisplayed = 10;

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

    final displayed = products.take(_maxDisplayed).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SnippetHomeScreenTitle(
          title: 'NEW IN THIS WEEK',
          onTap: () => NavigationHelper.push(
            context,
            const ProductListingScreen(
              title: 'New in this week',
              productType: ProductType.LATEST,
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
            itemCount: displayed.length,
            itemBuilder: (context, index) => Container(
              margin: EdgeInsets.only(
                right: Dimens.spacingSizeDefault,
                left: index == 0 ? Dimens.spacingSizeSmall : 0,
              ),
              width: SizeConfig.screenWidth * 0.6,
              child: ProductWidget(
                imageHeight: SizeConfig.screenHeight * 0.35,
                nameMaxLines: 1,
                payload: Product.fromDetail(displayed[index]),
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
