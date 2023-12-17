import 'package:flamingo/feature/order/data/model/order.dart';
import 'package:flamingo/feature/order/screen/order-status.dart/snippet_order_status_tab_item.dart';
import 'package:flamingo/widget/error/default_error_widget.dart';
import 'package:flutter/material.dart';

class SnippetOrderStatusTab extends StatelessWidget {
  const SnippetOrderStatusTab({
    Key? key,
    required this.orderItems,
    this.showDeliveryStatus = false,
    this.showPaymentStatus = false,
    required this.tabName,
  }) : super(key: key);

  final List<OrderItem> orderItems;
  final bool showDeliveryStatus;
  final bool showPaymentStatus;
  final String tabName;

  @override
  Widget build(BuildContext context) {
    return orderItems.isEmpty
        ? DefaultErrorWidget(
            errorMessage: 'No $tabName products.',
          )
        : ListView.builder(
            itemCount: orderItems.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: SnippetOrderStatusTabItem(
                  orderItem: orderItems[index],
                  showDeliveryStatus: showDeliveryStatus,
                  showPaymentStatus: showPaymentStatus,
                ),
              );
            });
  }
}
