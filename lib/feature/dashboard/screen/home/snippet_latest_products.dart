import 'package:flamingo/feature/product/screen/product-listing/product_listing_screen.dart';
import 'package:flamingo/feature/product/screen/product-listing/product_listing_view_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/product/product.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SnippetLatestProducts extends StatelessWidget {
  const SnippetLatestProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductListingViewModel>(
        builder: (context, viewModel, child) {
      final products = viewModel.getProductsUseCase.data?.rows ?? [];

      if (viewModel.getProductsUseCase.isLoading) {
        return _buildLoader();
      }

      if (!viewModel.getProductsUseCase.hasCompleted) {
        return const SizedBox();
      }

      return Column(
        children: [
          // if (provider.latestProductsList.isNotEmpty ||
          //     provider.gettingLatestProductList)
          SnippetHomeScreenTitle(
            title: 'LATEST',
            onTap: () {
              NavigationHelper.push(
                context,
                ProductListingScreen(
                    title: 'Latest', productType: ProductType.LATEST),
              );
            },
          ),
          Container(
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight * 0.47,
            margin:
                const EdgeInsets.symmetric(vertical: Dimens.spacingSizeSmall),
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: products.length > 6 ? 6 : products.length,
              itemBuilder: (context, index) => Container(
                margin: EdgeInsets.only(
                    right: Dimens.spacingSizeDefault,
                    left: index == 0 ? 10 : 0),
                // height: 280,
                width: SizeConfig.screenWidth * 0.6,
                child: ProductWidget(
                  imageHeight: SizeConfig.screenHeight * 0.35,
                  payload: GenericProduct(
                    product: products[index],
                    image: extractProductDefaultImage(
                      products[index].images,
                      products[index].variants,
                    ),
                    price: products[index].variants.first.price,
                    productId: products[index].id,
                    title: products[index].title,
                    vendor: products[index].vendor.storeName,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
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
    this.onTap,
    this.needSeeMore = true,
  }) : super(key: key);
  final String title;
  final VoidCallback? onTap;
  final bool needSeeMore;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.spacingSizeSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                title,
                style: textTheme(context).bodyLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          if (needSeeMore)
            InkWell(
              onTap: onTap,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: Text(
                'See More',
                style: TextStyle(
                  color: AppColors.grayMain,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
