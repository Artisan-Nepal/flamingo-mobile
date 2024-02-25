import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/cart/screen/cart-listing/cart_listing_screen.dart';
import 'package:flamingo/feature/product/data/model/product_detail.dart';
import 'package:flamingo/feature/product/screen/product-detail/product_detail_view_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/bottom-sheet/bottom_sheet_widget.dart';
import 'package:flamingo/widget/button/button.dart';
import 'package:flamingo/widget/image/cached_network_image_widget.dart';
import 'package:flamingo/widget/space/space.dart';
import 'package:flamingo/widget/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SnippetAddToCartBottomSheet extends StatefulWidget {
  const SnippetAddToCartBottomSheet({
    Key? key,
    required this.product,
  }) : super(key: key);

  final ProductDetail product;

  @override
  State<SnippetAddToCartBottomSheet> createState() =>
      _SnippetAddToCartBottomSheetState();
}

class _SnippetAddToCartBottomSheetState
    extends State<SnippetAddToCartBottomSheet> {
  final _viewModel = locator<ProductDetailViewModel>();

  @override
  void initState() {
    super.initState();
    _viewModel.setProduct(widget.product.id, widget.product);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _viewModel,
      builder: (context, child) {
        return BottomSheetWidget(
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
                      const HorizontalSpaceWidget(
                          width: Dimens.spacingSizeDefault),
                      Flexible(
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
                  const VerticalSpaceWidget(
                      height: Dimens.spacingSizeExtraLarge),
                  FilledButtonWidget(
                    width: double.infinity,
                    label: 'Go to bag',
                    onPressed: () {
                      NavigationHelper.pop(context);
                      NavigationHelper.push(context, const CartListingScreen());
                    },
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }
}
