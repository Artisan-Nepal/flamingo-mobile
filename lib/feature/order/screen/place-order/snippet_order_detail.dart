import 'package:flamingo/feature/cart/data/model/cart_item.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/image/cached_network_image_widget.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';

class SnippetOrderDetail extends StatelessWidget {
  const SnippetOrderDetail({Key? key, required this.cartItem})
      : super(key: key);

  final CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            fit: StackFit.loose,
            children: [
              Container(
                height: 90,
                width: 80,
                padding: const EdgeInsets.all(5),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300.withOpacity(0.6),
                        spreadRadius: 0.5,
                        blurRadius: 1,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImageWidget(
                      fit: BoxFit.cover,
                      image: cartItem.productVariant.image.url,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      shape: BoxShape.rectangle,
                      color: AppColors.grayDark),
                  child: Center(
                    child: Text(
                      cartItem.quantity.toString(),
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: Dimens.spacingSizeDefault),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                // Title
                Text(
                  cartItem.product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 5,
                ),
                Wrap(
                  spacing: Dimens.spacingSizeExtraSmall,
                  runSpacing: Dimens.spacingSizeExtraSmall,
                  children: [
                    Text('Color: ${cartItem.productVariant.color.name}'),
                    ...List<Widget>.generate(
                      cartItem.productVariant.attributes.length,
                      (index) {
                        final attribute =
                            cartItem.productVariant.attributes[index];
                        return Text(
                            '${attribute.name}: ${attribute.option.value}');
                      },
                    )
                  ],
                ),
                const VerticalSpaceWidget(height: Dimens.spacingSizeExtraSmall),
                // Price
                Text(
                  'Rs.${formatNepaliCurrency(cartItem.quantity * cartItem.productVariant.price)}',
                  style: const TextStyle(
                    color: AppColors.primaryMain,
                    fontSize: Dimens.fontSizeLarge,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
    );
  }
}
