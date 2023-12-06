import 'package:flamingo/feature/cart/data/model/cart_item.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/button/button.dart';
import 'package:flamingo/widget/image/cached_network_image_widget.dart';
import 'package:flamingo/widget/space/space.dart';
import 'package:flutter/material.dart';

class SnippetCartListingItem extends StatefulWidget {
  const SnippetCartListingItem({
    Key? key,
    required this.cartItem,
  }) : super(key: key);

  final CartItem cartItem;

  @override
  State<SnippetCartListingItem> createState() => _SnippetCartListingItemState();
}

class _SnippetCartListingItemState extends State<SnippetCartListingItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(bottom: Dimens.spacingSizeLarge),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 2,
              child: CachedNetworkImageWidget(
                image: widget.cartItem.productVariant.image.url,
                fit: BoxFit.cover,
                height: 150,
              ),
            ),
            const HorizontalSpaceWidget(width: Dimens.spacingSizeDefault),
            Flexible(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // title
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.cartItem.product.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const HorizontalSpaceWidget(
                          width: Dimens.spacingSizeDefault),

                      // Remove button
                      GestureDetector(
                        onTap: () {
                          _onRemove();
                        },
                        child: const Icon(
                          Icons.close,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                  const VerticalSpaceWidget(
                      height: Dimens.spacingSizeExtraSmall),
                  _buildVariantDetails(),
                  const VerticalSpaceWidget(height: Dimens.spacingSizeSmall),
                  _buildQuantityInStock(),
                  const VerticalSpaceWidget(height: Dimens.spacingSizeSmall),
                  _buildQuantityAdjuster(),
                  const VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Rs. ${formatNepaliCurrency(widget.cartItem.productVariant.price)}',
                      style: textTheme(context).labelLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVariantDetails() {
    final attributes = widget.cartItem.productVariant.attributes;
    return Wrap(
      spacing: Dimens.spacingSizeExtraSmall,
      runSpacing: Dimens.spacingSizeExtraSmall,
      children: [
        _buildInfoWrapper(widget.cartItem.productVariant.color.name),
        ...List<Widget>.generate(
          attributes.length,
          (index) {
            return _buildInfoWrapper(attributes[index].option.value);
          },
        )
      ],
    );
  }

  _buildQuantityInStock() {
    return _buildInfoWrapper(
      'Last ${widget.cartItem.productVariant.quantityInStock} left',
    );
  }

  _buildInfoWrapper(String info) {
    return Container(
      color:
          isLightMode(context) ? AppColors.grayLighter : AppColors.grayDarker,
      padding: const EdgeInsets.symmetric(
        vertical: Dimens.spacingSizeExtraSmall,
        horizontal: Dimens.spacingSizeSmall,
      ),
      child: Text(
        info,
        style: textTheme(context).bodySmall,
      ),
    );
  }

  Widget _buildQuantityAdjuster() {
    return Row(
      children: [
        SmallButtonWidget(
          height: 20,
          width: 20,
          enabled: widget.cartItem.quantity > 1,
          icon: Icons.remove,
          onPressed: () {
            _onDecrement();
          },
        ),
        const SizedBox(
          width: 5,
        ),
        Container(
          height: 20,
          width: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            widget.cartItem.quantity.toString(),
            style: TextStyle(
              color: themedPrimaryColor(context),
              fontSize: Dimens.fontSizeLarge,
              // color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        SmallButtonWidget(
          height: 20,
          width: 20,

          // enabled: widget.product.inStock == 1,
          icon: Icons.add,
          onPressed: () {
            _onIncrement();
          },
        ),
      ],
    );
  }

  _onRemove() {}

  _onIncrement() {
    // showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (context) => const CustomLoader());
    // Provider.of<CartProvider>(context, listen: false)
    //     .updateUserCart(cartId, quantity + 1, context, _afterUpdate);
  }

  _onDecrement() {
    // showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (context) => const CustomLoader());

    // Provider.of<CartProvider>(context, listen: false)
    //     .updateUserCart(cartId, quantity - 1, context, _afterUpdate);
  }

  _afterUpdate(bool success, String message, int cartId, int updatedQuantity,
      BuildContext context) {
    // // pop loading
    // Navigator.pop(context);
    // // Update quantity in selected cart list
    // if (success) {
    //   Provider.of<CheckoutProvider>(context, listen: false)
    //       .updateSelectedCartQuantity(cartId, updatedQuantity);
    // }
    // if (!success) {
    //   showDialog(
    //     context: context,
    //     builder: (context) => CustomAlertDialog(title: message),
    //   );
    // }
  }
}
