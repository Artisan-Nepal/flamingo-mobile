import 'package:flamingo/feature/order/data/model/order.dart';
import 'package:flamingo/feature/order/screen/order-detail/order_detail_screen.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/image/cached_network_image_widget.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';

class SnippetOrderListingItem extends StatelessWidget {
  const SnippetOrderListingItem({
    Key? key,
    required this.order,
    required this.showStatus,
  }) : super(key: key);

  final Order order;
  final bool showStatus;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigationHelper.push(context, OrderDetailScreen(order: order));
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: Dimens.spacingSizeDefault),
        color: AppColors.transparent,
        // height: 150,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Images
            Container(
              margin: const EdgeInsets.only(right: Dimens.spacingSizeDefault),
              // height: 80,
              // width: 80,
              decoration: BoxDecoration(
                color: AppColors.grayLight,
                borderRadius: BorderRadius.circular(Dimens.radius_5),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimens.radius_5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300.withOpacity(0.6),
                      spreadRadius: 0.5,
                      blurRadius: 1,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimens.radius_5),
                  child: CachedNetworkImageWidget(
                    image: extractProductVariantImage(
                      order.product.images,
                      order.productVariant,
                    ),
                    fit: BoxFit.cover,
                    height: 150,
                    width: 130,
                  ),
                ),
              ),
            ),

            // Description
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Order Id
                  Row(
                    children: [
                      Text(
                        'Order ID:  ',
                        style: TextStyle(
                          fontSize: Dimens.fontSizeDefault,
                          fontStyle: FontStyle.italic,
                          color: AppColors.grayMain,
                        ),
                      ),
                      Text(
                        order.orderCode.toString(),
                        style: TextStyle(
                          fontSize: Dimens.fontSizeDefault,
                          fontWeight: FontWeight.w600,
                          color: AppColors.grayMain,
                        ),
                      ),
                    ],
                  ),
                  const VerticalSpaceWidget(
                      height: Dimens.spacingSizeExtraSmall),
                  TextWidget(
                    order.product.vendor.storeName,
                    textOverflow: TextOverflow.ellipsis,
                    style: textTheme(context).bodyMedium!,
                  ),
                  const SizedBox(height: Dimens.spacingSizeExtraSmall),
                  TextWidget(
                    order.product.title,
                    maxLines: 1,
                    textOverflow: TextOverflow.ellipsis,
                    style: textTheme(context).bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  _buildInfoWrapper(context, 'Quantity: ${order.quantity}'),
                  const VerticalSpaceWidget(
                      height: Dimens.spacingSizeExtraSmall),

                  Row(
                    children: [
                      _buildInfoWrapper(
                          context, order.productVariant.color.name),
                      HorizontalSpaceWidget(
                          width: Dimens.spacingSizeExtraSmall),
                      _buildInfoWrapper(
                          context, order.productVariant.size.value),
                    ],
                  ),
                  const VerticalSpaceWidget(height: Dimens.spacingSizeSmall),

                  Text(
                    'Rs. ${formatNepaliCurrency(order.netTotal)}',
                    style: textTheme(context).labelLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  if (showStatus)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        order.orderStatus.name,
                        style: textTheme(context).bodyMedium!.copyWith(
                              fontStyle: FontStyle.italic,
                              color: AppColors.grayMain,
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

class OrderListItemTitleValue extends StatelessWidget {
  const OrderListItemTitleValue({
    Key? key,
    required this.title,
    required this.value,
    this.valueStyle = const TextStyle(),
  }) : super(key: key);

  final String title;
  final String value;
  final TextStyle valueStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$title:',
          style: const TextStyle(
            color: AppColors.grayMain,
            fontSize: Dimens.fontSizeDefault,
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Flexible(
          child: Text(
            value,
            style: valueStyle.copyWith(
              fontSize: Dimens.fontSizeDefault,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
