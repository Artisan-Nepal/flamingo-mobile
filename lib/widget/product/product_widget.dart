import 'package:flamingo/feature/auth/auth_view_model.dart';
import 'package:flamingo/feature/product/data/model/product_detail.dart';
import 'package:flamingo/feature/product/screen/product-detail/product_detail_screen.dart';
import 'package:flamingo/shared/enum/lead_source.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/fav-button/fav_product_button_widget.dart';
import 'package:flamingo/widget/image/image.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget({
    Key? key,
    this.nameMaxLines = 2,
    this.needFavIcon = true,
    required this.payload,
    this.imageHeight,
    this.leadSource,
    this.advertisementId,
  }) : super(key: key);

  final int nameMaxLines;
  final bool needFavIcon;
  final GenericProduct payload;
  final double? imageHeight;
  final LeadSource? leadSource;
  final String? advertisementId;

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return GestureDetector(
      onTap: () {
        NavigationHelper.push(
          context,
          ProductDetailScreen(
            productId: payload.productId,
            product: payload.product,
            title: payload.title,
            advertisementId: advertisementId,
            leadSource: leadSource,
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
                    height: imageHeight ?? SizeConfig.screenHeight * 0.3,
                    width: double.infinity,
                    child: CachedNetworkImageWidget(
                      image: payload.image,
                      fit: BoxFit.cover,
                      placeHolder: ImageConstants.imagePlaceholder,
                    ),
                  ),
                  if (authViewModel.isLoggedIn)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: FavProductButtonWidget(
                        productId: payload.productId,
                        advertisementId: advertisementId,
                        leadSource: leadSource,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
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
  final ProductDetail? product;

  GenericProduct({
    required this.image,
    required this.price,
    required this.productId,
    required this.title,
    required this.vendor,
    this.product,
  });
}
