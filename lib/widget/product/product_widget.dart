import 'package:flamingo/feature/auth/auth_view_model.dart';
import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/feature/product/screen/product-detail/product_detail_screen.dart';
import 'package:flamingo/shared/enum/lead_source.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/fav-button/fav_product_button_widget.dart';
import 'package:flamingo/widget/image/image.dart';
import 'package:flamingo/widget/rating/rating_badge_widget.dart';
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
    this.onTap,
  }) : super(key: key);

  final int nameMaxLines;
  final bool needFavIcon;
  final Product payload;
  final double? imageHeight;
  final LeadSource? leadSource;
  final String? advertisementId;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return GestureDetector(
      onTap: () {
        if (onTap != null) onTap!();
        NavigationHelper.push(
          context,
          ProductDetailScreen(
            productId: payload.productId,
            product: payload.product,
            title: payload.sellerStoreName,
            advertisementId: advertisementId,
            leadSource: leadSource,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        color: AppColors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Only the image carries the light-gray tile + rounded corners; the
            // text below sits flush-left on the page background (no card chrome),
            // matching the clean, chrome-less product cards this rail is modeled
            // on. The gray also shows through while the photo fades in.
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  Container(
                    height: imageHeight ?? SizeConfig.screenHeight * 0.3,
                    width: double.infinity,
                    color: isLightMode(context)
                        ? AppColors.grayLighter
                        : AppColors.grayDarker,
                    child: CachedNetworkImageWidget(
                      image: payload.image,
                      fit: BoxFit.cover,
                      needPlaceHolder: false,
                      fadeDuration: const Duration(milliseconds: 200),
                    ),
                  ),
                  if (authViewModel.isLoggedIn && needFavIcon)
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
            ),
            const SizedBox(height: Dimens.spacingSizeSmall),
            TextWidget(
              payload.sellerStoreName,
              maxLines: 1,
              textOverflow: TextOverflow.ellipsis,
              style: textTheme(context).bodyMedium!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: Dimens.spacing_2),
            TextWidget(
              payload.title,
              maxLines: nameMaxLines,
              textOverflow: TextOverflow.ellipsis,
              style: textTheme(context).bodyMedium!.copyWith(
                    color: AppColors.grayDark,
                  ),
            ),
            if (payload.averageRating != null) ...[
              const SizedBox(height: Dimens.spacing_2),
              RatingBadgeWidget(
                averageRating: payload.averageRating,
                reviewCount: payload.reviewCount,
              ),
            ],
            const SizedBox(height: Dimens.spacingSizeExtraSmall),
            Row(
              children: [
                TextWidget(
                  'Rs. ${formatNepaliCurrency(payload.price)}',
                  style: textTheme(context).labelLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                        color:
                            payload.isDiscounted ? AppColors.primaryMain : null,
                      ),
                ),
                if (payload.isDiscounted) ...[
                  const HorizontalSpaceWidget(
                      width: Dimens.spacingSizeExtraSmall),
                  Flexible(
                    child: TextWidget(
                      'Rs. ${formatNepaliCurrency(payload.originalPrice!)}',
                      textOverflow: TextOverflow.ellipsis,
                      style: textTheme(context).bodySmall!.copyWith(
                            color: AppColors.grayMain,
                            decoration: TextDecoration.lineThrough,
                          ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
