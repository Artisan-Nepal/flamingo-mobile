import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/feature/product/screen/product-detail/product_detail_screen.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/image/image.dart';
import 'package:flamingo/widget/space/space.dart';
import 'package:flutter/cupertino.dart';

// Compact inline prompt shown under a cart/wishlist line item when a visually
// similar, cheaper, in-stock product exists - a nudge to swap rather than a
// full product card.
class SnippetCheaperAlternativeBanner extends StatelessWidget {
  const SnippetCheaperAlternativeBanner({
    Key? key,
    required this.alternative,
  }) : super(key: key);

  final Product alternative;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigationHelper.push(
          context,
          ProductDetailScreen(
            productId: alternative.productId,
            title: alternative.sellerStoreName,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(Dimens.spacingSizeSmall),
        decoration: BoxDecoration(
          color: isLightMode(context)
              ? AppColors.grayLighter
              : AppColors.grayDarker,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: CachedNetworkImageWidget(
                image: alternative.image,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                needPlaceHolder: false,
              ),
            ),
            const HorizontalSpaceWidget(width: Dimens.spacingSizeSmall),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cheaper alternative available',
                    style: textTheme(context).bodySmall!.copyWith(
                          color: AppColors.grayMain,
                        ),
                  ),
                  Text(
                    alternative.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme(context).bodySmall!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
            const HorizontalSpaceWidget(width: Dimens.spacingSizeSmall),
            Text(
              'Rs. ${formatNepaliCurrency(alternative.price)}',
              style: textTheme(context).bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Icon(
              CupertinoIcons.chevron_right,
              size: Dimens.iconSizeSmall,
            ),
          ],
        ),
      ),
    );
  }
}
