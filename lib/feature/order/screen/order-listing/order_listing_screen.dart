import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/order/screen/order-listing/order_listing_view_model.dart';
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
            child: Container(),
          );
        },
      ),
    );
  }
}
