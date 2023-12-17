import 'package:flamingo/feature/order/data/model/order.dart';
import 'package:flamingo/feature/order/screen/order-detail/snippet_order_detail_info.dart';
import 'package:flamingo/feature/order/screen/place-order/snippet_order_detail.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/button/button.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({
    Key? key,
    required this.order,
  }) : super(key: key);

  final Order order;

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return DefaultScreen(
      appBarTitle: const Text('Order Details'),
      bottomNavigationBar: _buildBottomBar(),
      child: Column(
        children: [
          // Order and Estimated delivery date
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'Ordered on',
                        style: TextStyle(
                            // color: AppColors.primaryColor,
                            ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: themedPrimaryColor(context),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          formatDate(widget.order.createdAt,
                              format: DateFormatConstant.fullDate),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: Dimens.fontSizeLarge,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'Est. Delivery on',
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: themedPrimaryColor(context),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          formatDate(widget.order.estimatedDelivery,
                              format: DateFormatConstant.fullDate),
                          style: const TextStyle(
                            fontSize: Dimens.fontSizeLarge,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 25,
          ),

          // Products Detail
          _buildProductsDetail(),
          // const SizedBox(
          //   height: 20,
          // ),
// Billing Details
          _buildBillingDetails(),
          _buildDivider(),

          // Shipping address
          SnippetOrderDetailInfo(
            label: 'Shipping Address',
            value:
                '${widget.order.shippingAddress.name}, ${widget.order.shippingAddress.area.name}',
          ),
          _buildDivider(),
          // Billing address
          SnippetOrderDetailInfo(
            label: 'Billing Address',
            value:
                '${widget.order.billingAddress.name}, ${widget.order.billingAddress.area.name}',
          ),
          _buildDivider(),

          // Shipping Method
          SnippetOrderDetailInfo(
            label: 'Shipping Method',
            value: widget.order.shippingMethod.name,
          ),
          _buildDivider(),

          // Payment Method
          SnippetOrderDetailInfo(
            label: 'Payment Method',
            value: widget.order.paymentMethod.name,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: Dimens.spacingSizeSmall),
      child: Divider(
        thickness: 0.5,
      ),
    );
  }

  _buildBottomBar() {
    return FilledButtonWidget(
      label: 'View Order Status',
      onPressed: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => OrderStatusDetailsPage(
        //           orderCode: widget.order.code,
        //           orderDetails: widget.order.detail),
        //     ));
      },
    );
  }

  Widget _buildProductsDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'YOUR PRODUCT(S)',
            ),
            Text(
              ' (${widget.order.orderItems.length})',
              style: textTheme(context)
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          // height: SizeConfig.screenHeight * 0.14,
          constraints: BoxConstraints(maxHeight: SizeConfig.screenHeight * 0.4),
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowIndicator();
              return false;
            },
            child: NotificationListener<OverscrollNotification>(
              onNotification: (OverscrollNotification value) {
                if (value.overscroll < 0 &&
                    _scrollController.offset + value.overscroll <= 0) {
                  if (_scrollController.offset != 0) {
                    _scrollController.jumpTo(0);
                  }
                  return true;
                }
                if (_scrollController.offset + value.overscroll >=
                    _scrollController.position.maxScrollExtent) {
                  if (_scrollController.offset !=
                      _scrollController.position.maxScrollExtent) {
                    _scrollController
                        .jumpTo(_scrollController.position.maxScrollExtent);
                  }
                  return true;
                }
                _scrollController
                    .jumpTo(_scrollController.offset + value.overscroll);
                return true;
              },
              child: ListView.builder(
                  // physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.order.orderItems.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          bottom: Dimens.spacingSizeDefault),
                      child: SnippetOrderItem(
                        quantity: widget.order.orderItems[index].quantity,
                        productTitle:
                            widget.order.orderItems[index].product.title,
                        productVariant:
                            widget.order.orderItems[index].productVariant,
                      ),
                    );
                  }),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildBillingDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(
          thickness: 0.5,
        ),
        const SizedBox(height: 5),
        _buildOrderDetailItem(
            title: 'Order Cost',
            amount: widget.order.orderTotal - widget.order.shippingMethod.cost),
        _buildOrderDetailItem(
            title: 'Shipping Fee', amount: widget.order.shippingMethod.cost),
        _buildOrderDetailItem(
          title: 'Discount',
          isDiscount: true,
          amount: 0,
        ),
        const SizedBox(height: 5),
        _buildOrderDetailItem(
          title: 'Total ',
          amount: widget.order.orderTotal,
          boldText: true,
        ),
      ],
    );
  }

  Widget _buildOrderDetailItem({
    required String title,
    required int amount,
    bool boldText = false,
    bool isDiscount = false,
  }) {
    final textStyle = textTheme(context).titleSmall!.copyWith(
          fontWeight: boldText ? FontWeight.bold : null,
        );
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimens.spacingSizeExtraSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: textStyle,
          ),
          Text(
            isDiscount
                ? '-Rs. ${formatNepaliCurrency(amount)}'
                : 'Rs. ${formatNepaliCurrency(amount)}',
            style: textStyle,
          )
        ],
      ),
    );
  }
}