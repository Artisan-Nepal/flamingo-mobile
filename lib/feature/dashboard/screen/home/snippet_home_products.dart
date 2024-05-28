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
  }) : super(key: key);

  final List<ProductDetail> products;
  final bool isLoading;
  final ProductType productType;
  final String title;

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
                payload: Product(
                  quantity: products[index].variants.first.quantityInStock,
                  product: products[index],
                  image: extractProductDefaultImage(
                    products[index].images,
                    products[index].variants,
                  ),
                  price: products[index].variants.first.price,
                  productId: products[index].id,
                  title: products[index].title,
                  sellerStoreName: products[index].seller.storeName,
                ),
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
                      fontWeight: FontWeight.w500,
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
