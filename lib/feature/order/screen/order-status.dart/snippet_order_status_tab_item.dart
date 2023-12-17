import 'package:flamingo/feature/order/data/model/order.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/image/cached_network_image_widget.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';

class SnippetOrderStatusTabItem extends StatelessWidget {
  const SnippetOrderStatusTabItem({
    Key? key,
    required this.orderItem,
    this.showDeliveryStatus = false,
    this.showPaymentStatus = false,
  }) : super(key: key);

  final OrderItem orderItem;
  final bool showDeliveryStatus;
  final bool showPaymentStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            child: Stack(
              fit: StackFit.loose,
              children: [
                Container(
                  height: 130,
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300.withOpacity(0.6),
                          spreadRadius: 0.5,
                          blurRadius: 1,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(Dimens.radius_5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimens.radius_5),
                      child: CachedNetworkImageWidget(
                        fit: BoxFit.cover,
                        image: orderItem.productVariant.image.url,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        shape: BoxShape.rectangle,
                        color: AppColors.grayDark),
                    child: Center(
                      child: Text(
                        orderItem.quantity.toString(),
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
          ),
          const SizedBox(width: 10),
          Flexible(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                TextWidget(
                  orderItem.product.vendor.storeName,
                  textOverflow: TextOverflow.ellipsis,
                  style: textTheme(context).bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const VerticalSpaceWidget(height: Dimens.spacingSizeExtraSmall),
                TextWidget(
                  orderItem.product.title,
                  textOverflow: TextOverflow.ellipsis,
                  style: textTheme(context).bodyMedium!,
                ),

                // Desc
                const VerticalSpaceWidget(height: Dimens.spacingSizeSmall),
                _buildVariantDetails(context),
                const VerticalSpaceWidget(height: Dimens.spacingSizeSmall),

                // delivery status
                if (showDeliveryStatus) ...[
                  Container(
                    decoration: BoxDecoration(
                        color: themedPrimaryColor(context),
                        borderRadius: BorderRadius.circular(5)),
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                    child: Text(
                      orderItem.orderStatus.name,
                      style: TextStyle(
                        color: isLightMode(context)
                            ? AppColors.white
                            : AppColors.black,
                        fontSize: Dimens.fontSizeSmall,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Rs. ${formatNepaliCurrency(orderItem.price)}',
                    style: textTheme(context).labelLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
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

  Widget _buildVariantDetails(BuildContext context) {
    final attributes = orderItem.productVariant.attributes;
    return Wrap(
      spacing: Dimens.spacingSizeExtraSmall,
      runSpacing: Dimens.spacingSizeExtraSmall,
      children: [
        _buildInfoWrapper(context, orderItem.productVariant.color.name),
        ...List<Widget>.generate(
          attributes.length,
          (index) {
            return _buildInfoWrapper(context, attributes[index].option.value);
          },
        )
      ],
    );
  }

  _buildInfoWrapper(BuildContext context, String info) {
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
}
