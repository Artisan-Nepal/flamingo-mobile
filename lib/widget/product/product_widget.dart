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
    this.nameMaxLines = 2,
    this.needFavIcon = true,
    required this.payload,
  }) : super(key: key);

  final int nameMaxLines;
  final bool needFavIcon;
  final GenericProduct payload;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigationHelper.push(
          context,
          ProductDetailScreen(
            productId: payload.productId,
            product: payload.product,
            title: payload.title,
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
                      image: payload.image,
                      fit: BoxFit.cover,
                      placeHolder: ImageConstants.imagePlaceholder,
                    ),
                  ),
                  if (needFavIcon)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: FavButtonWidget(
                        productId: payload.productId,
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
                      payload.vendor,
                      textOverflow: TextOverflow.ellipsis,
                      style: textTheme(context).bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    // const SizedBox(height: Dimens.spacingSizeExtraSmall),
                    TextWidget(
                      payload.title,
                      maxLines: nameMaxLines,
                      textOverflow: TextOverflow.ellipsis,
                      style: textTheme(context).bodyMedium!,
                    ),
                    const SizedBox(height: Dimens.spacingSizeExtraSmall),
                    TextWidget(
                      'Rs. ${formatNepaliCurrency(payload.price)}',
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

class GenericProduct {
  final String productId;
  final String title;
  final String image;
  final String vendor;
  final int price;
  final Product? product;

  GenericProduct({
    required this.image,
    required this.price,
    required this.productId,
    required this.title,
    required this.vendor,
    this.product,
  });
}
