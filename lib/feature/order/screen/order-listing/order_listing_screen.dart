import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/order/data/model/order.dart';
import 'package:flamingo/feature/order/screen/order-listing/order_listing_view_model.dart';
import 'package:flamingo/feature/order/screen/order-listing/snippet_order_listing_tab.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/loader/loader.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderListingScreen extends StatefulWidget {
  const OrderListingScreen({super.key});

  @override
  State<OrderListingScreen> createState() => _OrderListingScreenState();
}

class _OrderListingScreenState extends State<OrderListingScreen> {
  final _viewModel = locator<OrderListingViewModel>();

  @override
  void initState() {
    super.initState();
    _viewModel.getUserOrders();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _viewModel,
      child: Consumer<OrderListingViewModel>(
        builder: (context, viewModel, child) {
          return TitledScreen(
            title: 'Orders (2)',
            scrollable: false,
            child: DefaultTabController(
              animationDuration: Duration.zero,
              length: orderStatus.length + 1,
              child: Column(
                children: [
                  _buildTabBar(),
                  !viewModel.orderUseCase.hasCompleted
                      ? const DefaultScreenLoaderWidget()
                      : _buildTabBarView(viewModel),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Container _buildTabBar() {
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

  Widget _buildTabBarView(OrderListingViewModel viewModel) {
    final orders = viewModel.orderUseCase.data?.rows ?? [];
    return Expanded(
      child: Consumer(
        builder: (context, provider, child) => TabBarView(
          children: [
            // All
            SnippetOrderListingTab(
              orders: orders,
              tabName: 'All',
              showStatus: true,
            ),

            ...List<SnippetOrderListingTab>.from(
              orderStatus.map(
                (status) => SnippetOrderListingTab(
                  tabName: status.name,
                  orders: List<Order>.from(
                    orders.where(
                      (order) =>
                          order.orderStatus.sequenceNumber ==
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
}
