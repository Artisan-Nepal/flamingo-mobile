import 'package:flamingo/feature/product/data/model/product_detail.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';

// Renders a variant's price for the colour/size pickers: the effectivePrice
// (post-discount) and, when a discount is active, the original list price
// struck through beside it - so per-variant discounts are visible where the
// customer actually picks a colour/size, not just in the main price block.
class VariantPriceText extends StatelessWidget {
  const VariantPriceText({super.key, required this.variant});

  final ProductVariant variant;

  @override
  Widget build(BuildContext context) {
    final hasDiscount = variant.originalPrice != null;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            'Rs. ${formatNepaliCurrency(variant.effectivePrice)}',
            overflow: TextOverflow.ellipsis,
            style: textTheme(context).labelLarge!.copyWith(
                  color: hasDiscount ? AppColors.secondaryMain : null,
                ),
          ),
        ),
        if (hasDiscount) ...[
          const HorizontalSpaceWidget(width: Dimens.spacingSizeExtraSmall),
          Flexible(
            child: Text(
              'Rs. ${formatNepaliCurrency(variant.originalPrice!)}',
              overflow: TextOverflow.ellipsis,
              style: textTheme(context).labelSmall!.copyWith(
                    color: AppColors.grayMain,
                    decoration: TextDecoration.lineThrough,
                  ),
            ),
          ),
        ],
      ],
    );
  }
}
