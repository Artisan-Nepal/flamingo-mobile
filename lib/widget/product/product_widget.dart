import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/feature/product/screen/product-detail/product_detail_screen.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/fav-button/fav_button_widget.dart';
import 'package:flamingo/widget/image/image.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget({
    Key? key,
    required this.product,
    this.nameMaxLines = 2,
    this.needFavIcon = true,
  }) : super(key: key);

  final Product product;
  final int nameMaxLines;
  final bool needFavIcon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigationHelper.push(
          context,
          ProductDetailScreen(
            product: product,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 1),
        decoration: BoxDecoration(
          color: isLightMode(context)
              ? AppColors.grayLighter
              : AppColors.grayDarker,
          borderRadius: BorderRadius.circular(6),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 170,
                    width: double.infinity,
                    child: CachedNetworkImageWidget(
                      image: product.variants[0].image.url,
                      fit: BoxFit.cover,
                      placeHolder: ImageConstants.imagePlaceholder,
                    ),
                  ),
                  if (needFavIcon)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: FavButtonWidget(
                        productId: product.id,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimens.spacingSizeSmall,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      product.vendor.storeName,
                      textOverflow: TextOverflow.ellipsis,
                      style: textTheme(context).bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    // const SizedBox(height: Dimens.spacingSizeExtraSmall),
                    TextWidget(
                      product.title,
                      maxLines: nameMaxLines,
                      textOverflow: TextOverflow.ellipsis,
                      style: textTheme(context).bodyMedium!,
                    ),
                    const SizedBox(height: Dimens.spacingSizeExtraSmall),
                    TextWidget(
                      'Rs. ${formatNepaliCurrency(product.variants[0].price)}',
                      style: textTheme(context).labelLarge!,
                    ),
                    const SizedBox(height: Dimens.spacingSizeSmall),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
