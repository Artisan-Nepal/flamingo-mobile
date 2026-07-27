import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/cart/screen/cart-listing/cart_listing_screen.dart';
import 'package:flamingo/feature/fit-reference/data/fit_reference_repository.dart';
import 'package:flamingo/feature/fit-reference/screen/fit-reference-listing/fit_reference_listing_screen.dart';
import 'package:flamingo/feature/product/screen/product-detail/product_detail_view_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/bottom-sheet/bottom_sheet_widget.dart';
import 'package:flamingo/widget/button/button.dart';
import 'package:flamingo/widget/image/cached_network_image_widget.dart';
import 'package:flamingo/widget/space/space.dart';
import 'package:flamingo/widget/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

// Generic excitement about the purchase itself - deliberately says nothing
// about sizing or fit, since this sheet never actually checks whether this
// item fits the customer's saved measurements.
const List<String> _excitementMessages = [
  'Ready to own it?',
  'Soon yours!',
  "You're going to love this",
];

class SnippetAddToCartSummaryBottomSheet extends StatefulWidget {
  const SnippetAddToCartSummaryBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  State<SnippetAddToCartSummaryBottomSheet> createState() =>
      _SnippetAddToCartSummaryBottomSheetState();
}

class _SnippetAddToCartSummaryBottomSheetState
    extends State<SnippetAddToCartSummaryBottomSheet> {
  // null while the check is in flight (or on error) - the nudge only renders
  // once we're sure there are no saved measurements, so a slow/failed lookup
  // never flashes the row on and then off.
  bool? _hasNoSavedMeasurements;
  // Picked once per sheet appearance, not on every rebuild, so it doesn't
  // change mid-view.
  late final String _excitementMessage =
      _excitementMessages[Random().nextInt(_excitementMessages.length)];

  @override
  void initState() {
    super.initState();
    _checkSavedMeasurements();
  }

  Future<void> _checkSavedMeasurements() async {
    try {
      final references =
          await locator<FitReferenceRepository>().getFitReferences();
      if (mounted) {
        setState(() => _hasNoSavedMeasurements = references.isEmpty);
      }
    } catch (_) {
      // Stay quiet on failure - this is a soft nudge, not worth surfacing an
      // error for.
    }
  }

  // null while the check is in flight (or on error), so the header row stays
  // bare rather than flashing a message on and then off.
  Widget? _buildTopContent(BuildContext context) {
    if (_hasNoSavedMeasurements == null) return null;

    if (_hasNoSavedMeasurements!) {
      return GestureDetector(
        onTap: () => NavigationHelper.push(
          context,
          const FitReferenceListingScreen(),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.straighten,
              size: Dimens.iconSize_15,
              color: AppColors.grayMain,
            ),
            const HorizontalSpaceWidget(width: Dimens.spacingSizeExtraSmall),
            Expanded(
              child: TextWidget(
                'Add your measurements for a better fit on this purchase',
                style: textTheme(context).bodySmall!.copyWith(
                      color: AppColors.grayDark,
                    ),
              ),
            ),
          ],
        ),
      );
    }

    // Customer already has saved measurements - a small celebratory payoff
    // instead of a bare header row. Deliberately generic (not a size/fit
    // claim - see _excitementMessages) and rotated so it isn't the exact
    // same line on every add-to-bag.
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Icons.auto_awesome,
          size: Dimens.iconSize_15,
          color: AppColors.secondaryMain,
        ),
        const HorizontalSpaceWidget(width: Dimens.spacingSizeExtraSmall),
        Expanded(
          child: TextWidget(
            _excitementMessage,
            style: textTheme(context).bodySmall!.copyWith(
                  color: AppColors.secondaryMain,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      topContent: _buildTopContent(context),
      child: Consumer<ProductDetailViewModel>(
        builder: (context, viewModel, child) {
          final product = viewModel.productUseCase.data!;
          final variant = viewModel.selectedVariant;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                'Added to Bag',
                style: textTheme(context).bodyLarge!,
              ),
              const VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: CachedNetworkImageWidget(
                      height: 200,
                      image: extractProductVariantImage(
                        viewModel.productUseCase.data!.images,
                        viewModel.selectedVariant,
                      ),
                    ),
                  ),
                  const HorizontalSpaceWidget(width: Dimens.spacingSizeDefault),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          product.seller.storeName,
                          textOverflow: TextOverflow.ellipsis,
                          style: textTheme(context).bodyMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        TextWidget(
                          product.title,
                          style: textTheme(context).bodyMedium!,
                        ),
                        const SizedBox(height: Dimens.spacingSizeDefault),

                        // color
                        TextWidget(
                          'Color:  ${variant.color.name}',
                          style: textTheme(context).bodyMedium!,
                        ),
                        TextWidget(
                          'Size:  ${variant.size.value}',
                          style: textTheme(context).bodyMedium!,
                        ),
                        // attributes
                        // ...List<Widget>.generate(
                        //   variant.attributes.length,
                        //   (index) => Column(
                        //     children: [
                        //       const SizedBox(
                        //           height: Dimens.spacingSizeExtraSmall),
                        //       TextWidget(
                        //         '${variant.attributes[index].name}:  ${variant.attributes[index].option.value}',
                        //         style: textTheme(context).bodyMedium!,
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        const SizedBox(height: Dimens.spacingSizeDefault),
                        TextWidget(
                          'Rs. ${formatNepaliCurrency(variant.price)}',
                          style: textTheme(context).labelLarge!,
                        ),
                        const SizedBox(height: Dimens.spacingSizeSmall),
                      ],
                    ),
                  )
                ],
              ),
              const VerticalSpaceWidget(height: Dimens.spacingSizeExtraLarge),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButtonWidget(
                      label: 'Continue Shopping',
                      onPressed: () {
                        NavigationHelper.pop(context);
                      },
                    ),
                  ),
                  const HorizontalSpaceWidget(
                      width: Dimens.spacingSizeSmall),
                  Expanded(
                    child: FilledButtonWidget(
                      width: double.infinity,
                      label: 'Go to bag',
                      onPressed: () {
                        NavigationHelper.pop(context);
                        NavigationHelper.push(
                            context, const CartListingScreen());
                      },
                    ),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
