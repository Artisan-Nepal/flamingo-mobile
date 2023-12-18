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
              length: orderStatusLookup.length + 1,
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
            ...List<Tab>.from(
              orderStatusLookup.map(
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
              orderStatusLookup.map(
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
