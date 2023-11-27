import 'package:flamingo/feature/product/screen/product-detail/product_detail_screen.dart';
import 'package:flamingo/feature/wishlist/data/model/wishlist_item.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/image/image.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';

class SnippetWishListItem extends StatelessWidget {
  const SnippetWishListItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  final WishlistItem item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _navigateToProductDetail(context);
      },
      child: Container(
        color: Colors.transparent,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CachedNetworkImageWidget(
                      image: item.product.variants.first.image.url,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.close,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const VerticalSpaceWidget(height: Dimens.spacingSizeExtraSmall),

            TextWidget(
              item.product.vendor.storeName,
              style: textTheme(context).bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextWidget(
              item.product.title,
              style: textTheme(context).bodyMedium!,
            ),
            const SizedBox(height: Dimens.spacingSizeExtraSmall),
            TextWidget(
              'Rs. ${formatNepaliCurrency(item.product.variants.first.price)}',
              style: textTheme(context).labelLarge!,
            ),
            const SizedBox(height: Dimens.spacingSizeExtraSmall),
            OutlinedButtonWidget(
              label: 'Add to bag',
              fontSize: Dimens.fontSizeDefault,
              onPressed: () {
                _navigateToProductDetail(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToProductDetail(BuildContext context) {
    NavigationHelper.push(
      context,
      ProductDetailScreen(
        productId: item.id,
        product: item.product,
      ),
    );
  }
}
