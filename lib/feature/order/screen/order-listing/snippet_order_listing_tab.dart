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
    this.emptyMessage,
    required this.onRefresh,
  }) : super(key: key);

  final List<Order> orders;
  final bool showStatus;
  final String tabName;
  final String? emptyMessage;
  final Future<void> Function() onRefresh;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: onRefresh,
      child: orders.isEmpty
          ? DefaultErrorWidget(
              useListView: true,
              manuallyCenter: true,
              errorMessage: emptyMessage ?? 'No products here',
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
              },
            ),
    );
  }
}
