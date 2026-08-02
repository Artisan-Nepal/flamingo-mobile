import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/feature/product/data/model/product_detail.dart';
import 'package:flamingo/feature/product/screen/product-listing/product_listing_screen.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/product/product.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';

class SnippetHomeProducts extends StatelessWidget {
  const SnippetHomeProducts({
    Key? key,
    required this.products,
    this.isLoading = false,
    required this.productType,
    required this.title,
    this.categoryId,
  }) : super(key: key);

  final List<ProductDetail> products;
  final bool isLoading;
  final ProductType productType;
  final String title;

  // When set (e.g. a "For You" category row), "See More" opens that category's
  // listing instead of a productType-based one.
  final String? categoryId;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoader();
    }

    if (products.isEmpty) {
      return const SizedBox();
    }

    return Column(
      children: [
        // if (provider.latestProductsList.isNotEmpty ||
        //     provider.gettingLatestProductList)
        SnippetHomeScreenTitle(
          title: title.toUpperCase(),
          onTap: () {
            NavigationHelper.push(
              context,
              ProductListingScreen(
                title: title,
                productType: productType,
                categoryId: categoryId,
              ),
            );
          },
        ),
        Container(
          width: SizeConfig.screenWidth,
          height: SizeConfig.screenHeight * 0.47,
          margin: const EdgeInsets.symmetric(vertical: Dimens.spacingSizeSmall),
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: products.length > 6 ? 6 : products.length,
            itemBuilder: (context, index) => Container(
              margin: EdgeInsets.only(
                  right: Dimens.spacingSizeDefault, left: index == 0 ? 10 : 0),
              // height: 280,
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
          VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
          Row(
            children: [
              Container(
                color: AppColors.grayLighter,
                height: SizeConfig.screenHeight * 0.3,
                width: 300,
              ),
              HorizontalSpaceWidget(width: Dimens.spacingSizeSmall),
              Expanded(
                child: Container(
                  color: AppColors.grayLighter,
                  height: SizeConfig.screenHeight * 0.3,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class SnippetHomeScreenTitle extends StatelessWidget {
  const SnippetHomeScreenTitle({
    Key? key,
    required this.title,
    this.subtitle,
    this.onTap,
    this.needSeeMore = true,
  }) : super(key: key);
  final String title;
  // The one-line "why am I seeing this" reason shown under the title (see
  // HOME_SCREEN_OVERHAUL_PLAN.md §5.1) - optional so existing headers that
  // don't pass one render exactly as before.
  final String? subtitle;
  final VoidCallback? onTap;
  final bool needSeeMore;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.spacingSizeSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // A long title (e.g. a category name in "Because you've been
              // looking at X") is unbounded text with no truncation - without
              // Expanded here it pushes straight through "See More" and
              // overflows the row instead of yielding space to it.
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme(context).bodyLarge!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              if (needSeeMore) ...[
                const HorizontalSpaceWidget(width: Dimens.spacingSizeSmall),
                InkWell(
                  onTap: onTap,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: const Icon(
                    Icons.chevron_right,
                    color: AppColors.grayMain,
                  ),
                ),
              ],
            ],
          ),
          if (subtitle != null) ...[
            const VerticalSpaceWidget(height: Dimens.spacing_2),
            Text(
              subtitle!,
              style: textTheme(context).bodySmall!.copyWith(
                    color: AppColors.grayMain,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
