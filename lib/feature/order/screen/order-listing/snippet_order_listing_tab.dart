import 'package:flamingo/feature/order/data/model/order.dart';
import 'package:flamingo/feature/order/screen/order-listing/snippet_order_listing_item.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/error/default_error_widget.dart';
import 'package:flutter/material.dart';

class SnippetOrderListingTab extends StatelessWidget {
  const SnippetOrderListingTab({
    Key? key,
    required this.orders,
    this.showStatus = false,
    required this.tabName,
  }) : super(key: key);

  final List<Order> orders;
  final bool showStatus;
  final String tabName;

  @override
  Widget build(BuildContext context) {
    return orders.isEmpty
        ? DefaultErrorWidget(
            errorMessage: 'No $tabName products.',
          )
        : ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: Dimens.spacingSizeSmall),
                child: SnippetOrderListingItem(
                  // productTitle: orders[index].product.title,
                  // productVariant: orders[index].productVariant,
                  // quantity: orders[index].quantity,
                  // showStatus: showStatus,
                  order: orders[index],
                  showStatus: showStatus,
                ),
              );
            });
  }
}
