import 'package:flamingo/feature/order/data/model/order.dart';
import 'package:flamingo/feature/order/screen/order-status.dart/snippet_order_status_tab.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderStatusScreen extends StatelessWidget {
  const OrderStatusScreen({Key? key, required this.order}) : super(key: key);

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order ID: ${order.orderId.toString()}')),
      body: Consumer(
        builder: (context, provider, child) => DefaultTabController(
          animationDuration: Duration.zero,
          length: orderStatus.length + 1,
          child: Column(
            children: [_buildTabBar(context), _buildTabBarView()],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBarView() {
    return Expanded(
      child: Consumer(
        builder: (context, provider, child) => TabBarView(
          children: [
            // All
            SnippetOrderStatusTab(
              orderItems: order.orderItems,
              tabName: 'All',
              showDeliveryStatus: true,
              showPaymentStatus: true,
            ),

            ...List<SnippetOrderStatusTab>.from(
              orderStatus.map(
                (status) => SnippetOrderStatusTab(
                  tabName: status.name,
                  showPaymentStatus: true,
                  orderItems: List<OrderItem>.from(
                    order.orderItems.where(
                      (orderDetail) =>
                          orderDetail.orderStatus.sequenceNumber ==
                          status.sequenceNumber,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildTabBar(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
          color: isLightMode(context) ? AppColors.white : AppColors.black,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0.5,
              blurRadius: 1,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ]),
      child: Consumer(
        builder: (context, provider, child) => TabBar(
          unselectedLabelColor:
              isLightMode(context) ? AppColors.grayMain : AppColors.grayLight,
          labelColor: themedPrimaryColor(context),
          isScrollable: true,
          labelStyle: const TextStyle(
              fontSize: Dimens.fontSizeDefault, fontWeight: FontWeight.bold),
          indicatorColor: themedPrimaryColor(context),
          labelPadding: const EdgeInsets.symmetric(horizontal: 20),
          tabs: [
            const Tab(
              child: Text('All'),
            ),
            ...List<Tab>.from(
              orderStatus.map(
                (e) => Tab(
                  child: Text(e.name),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
