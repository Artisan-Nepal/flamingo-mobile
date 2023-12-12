import 'package:flamingo/feature/order/data/model/order.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/image/cached_network_image_widget.dart';
import 'package:flutter/material.dart';

class OrdersListItem extends StatelessWidget {
  const OrdersListItem({
    Key? key,
    required this.order,
  }) : super(key: key);

  final Order order;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 90,
      child: Row(
        children: [
          // Images
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: AppColors.grayLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300.withOpacity(0.6),
                    spreadRadius: 0.5,
                    blurRadius: 1,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: _buildGrid(order.orderItems
                    .map((e) => e.productVariant.image.url)
                    .toList()),
              ),
            ),
          ),

          // Description
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // OrderListItemTitleValue(
                  //   title: 'Order ID',
                  //   value: orderId.toString(),
                  // ),
                  // Order Id
                  Container(
                    // height: 20,
                    // width: 70,
                    decoration: BoxDecoration(
                      color: AppColors.primaryMain,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.all(5),
                    child: Wrap(
                      children: [
                        const Text(
                          'Order ID:  ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Dimens.fontSizeSmall,
                          ),
                        ),
                        Text(
                          order.id,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: Dimens.fontSizeSmall,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  OrderListItemTitleValue(
                    title: 'Order Date',
                    value: order.createdAt.toString(),
                  ),
                  // OrderListItemTitleValue(
                  //   title: 'Est. Delivery Date',
                  //   value: deliveryDate,
                  // ),
                  OrderListItemTitleValue(
                    title: 'Total Price',
                    value: 'Rs. ${order.orderTotal}',
                    valueStyle: const TextStyle(
                      color: AppColors.primaryMain,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Arrow Icon
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  _buildGrid(List<String> images) {
    if (images.length == 1) {
      return CachedNetworkImageWidget(
        image: images[0],
        fit: BoxFit.cover,
      );
    } else if (images.length == 2) {
      return Row(
        children: [
          Expanded(
            child: CachedNetworkImageWidget(
              image: images[0],
              fit: BoxFit.cover,
              height: 80,
            ),
          ),
          Expanded(
            child: CachedNetworkImageWidget(
              image: images[1],
              fit: BoxFit.cover,
              height: 80,
            ),
          ),
        ],
      );
    } else {
      return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
          mainAxisExtent: 40,
        ),
        itemCount: images.length > 3 ? 4 : images.length,
        itemBuilder: (context, gridIndex) => Stack(
          children: [
            CachedNetworkImageWidget(
              image: images[gridIndex],
              fit: BoxFit.cover,
            ),
            if (gridIndex == 3)
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                ),
                child: Center(
                    child: Text(
                  '+${(images.length - 4).toString()}',
                  style: const TextStyle(color: Colors.white),
                )),
              )
          ],
        ),
      );
    }
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
            fontSize: Dimens.fontSizeSmall,
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Flexible(
          child: Text(
            value,
            style: valueStyle.copyWith(
              fontSize: Dimens.fontSizeSmall,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
