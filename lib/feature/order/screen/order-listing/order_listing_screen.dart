import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/customer-activity/customer_activity_view_model.dart';
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
    final orderCount =
        Provider.of<CustomerActivityViewModel>(context).orderCount;

    return ChangeNotifierProvider(
      create: (context) => _viewModel,
      child: Consumer<OrderListingViewModel>(
        builder: (context, viewModel, child) {
          return TitledScreen(
            title: 'Orders ($orderCount)',
            scrollable: false,
            padding: EdgeInsets.zero,
            child: DefaultTabController(
              animationDuration: Duration.zero,
              length: 4,
              child: Column(
                children: [
                  _buildTabBar(),
                  viewModel.orderUseCase.isLoading
                      ? const DefaultScreenLoaderWidget(
                          manuallyCenter: true,
                        )
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
      margin: EdgeInsets.symmetric(horizontal: Dimens.spacingSizeDefault),
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isLightMode(context)
                ? AppColors.grayLighter
                : AppColors.grayDarker,
            width: 1,
          ),
        ),
      ),
      child: Consumer(
        builder: (context, provider, child) => TabBar(
          tabAlignment: TabAlignment.start,
          unselectedLabelColor:
              isLightMode(context) ? AppColors.grayDarker : AppColors.white,
          labelColor:
              isLightMode(context) ? AppColors.grayDarker : AppColors.white,
          isScrollable: true,
          labelStyle: textTheme(context)
              .titleSmall!
              .copyWith(fontWeight: FontWeight.bold),
          unselectedLabelStyle: textTheme(context).titleSmall!,
          indicatorColor:
              isLightMode(context) ? AppColors.grayDarker : AppColors.white,
          labelPadding:
              const EdgeInsets.symmetric(horizontal: Dimens.spacingSizeSmall),
          tabs: [
            const Tab(
              child: Text('All'),
            ),
            Tab(
              child: Text('To Receive'),
            ),
            Tab(
              child: Text('Received'),
            ),
            Tab(
              child: Text('Cancelled'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBarView(OrderListingViewModel viewModel) {
    final orders = viewModel.orderUseCase.data?.rows ?? [];
    return Expanded(
      child: Consumer<OrderListingViewModel>(
        builder: (context, viewModel, child) => TabBarView(
          children: [
            // All
            SnippetOrderListingTab(
                orders: orders,
                tabName: 'All',
                error: viewModel.orderUseCase.exception,
                showStatus: true,
                emptyMessage: 'You have not placed any orders',
                onRefresh: () async {
                  await _viewModel.getUserOrders(isRefresh: true);
                }),

            // To Receive
            SnippetOrderListingTab(
                tabName: 'To Receive',
                showStatus: true,
                error: viewModel.orderUseCase.exception,
                orders: List<Order>.from(
                  orders.where(
                    (order) => ['PENDING', 'PROCESSING', 'OUT_FOR_DELIVERY']
                        .contains(order.orderStatus.code),
                  ),
                ),
                onRefresh: () async {
                  await _viewModel.getUserOrders(isRefresh: true);
                }),
            // Received
            SnippetOrderListingTab(
                tabName: 'Received',
                error: viewModel.orderUseCase.exception,
                orders: List<Order>.from(
                  orders.where(
                    (order) => order.orderStatus.code == 'DELIVERED',
                  ),
                ),
                onRefresh: () async {
                  await _viewModel.getUserOrders(isRefresh: true);
                }),
            // Cancelled
            SnippetOrderListingTab(
              tabName: 'Cancelled',
              error: viewModel.orderUseCase.exception,
              orders: List<Order>.from(
                orders.where(
                  (order) => order.orderStatus.code == 'CANCELLED',
                ),
              ),
              onRefresh: () async {
                await _viewModel.getUserOrders(isRefresh: true);
              },
            ),
          ],
        ),
      ),
    );
  }
}
