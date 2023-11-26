import 'package:flamingo/feature/wishlist/data/model/wishlist_item.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/image/image.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';

class SnippetWishListItem extends StatelessWidget {
  const SnippetWishListItem({
    Key? key,
    required this.item,
    this.onPressed,
    this.onRemove,
  }) : super(key: key);

  final WishlistItem item;
  final VoidCallback? onRemove;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
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
                      image: item.variants.first.image.url[0],
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
              item.vendor.storeName,
              style: textTheme(context).bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextWidget(
              item.title,
              style: textTheme(context).bodyMedium!,
            ),
            const SizedBox(height: Dimens.spacingSizeExtraSmall),
            TextWidget(
              'Rs. ${formatNepaliCurrency(item.variants[0].price)}',
              style: textTheme(context).labelLarge!,
            ),
            const SizedBox(height: Dimens.spacingSizeExtraSmall),
            OutlinedButtonWidget(
              label: 'Add to Cart',
              fontSize: Dimens.fontSizeDefault,
              onPressed: () {
                NavigationHelper.push(
                  context,
                  ProductDetailScreen(
                    productId: item.id,
                    item: item,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
