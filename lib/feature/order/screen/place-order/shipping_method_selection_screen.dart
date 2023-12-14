import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/order/screen/place-order/checkout_method_view_model.dart';
import 'package:flamingo/feature/order/screen/place-order/place_order_view_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/loader/circular_progress_indicator_widget.dart';
import 'package:flamingo/widget/screen/default_screen.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShippingMethodSelectionScreen extends StatefulWidget {
  const ShippingMethodSelectionScreen({Key? key}) : super(key: key);

  @override
  State<ShippingMethodSelectionScreen> createState() =>
      _ShippingMethodSelectionScreenState();
}

class _ShippingMethodSelectionScreenState
    extends State<ShippingMethodSelectionScreen> {
  final _viewModel = locator<CheckoutMethodViewModel>();

  @override
  void initState() {
    super.initState();
    _viewModel.getShippingMethods();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _viewModel,
      child: DefaultScreen(
        scrollable: false,
        appBarTitle: const Text('Select a shipping method'),
        child: Consumer<PlaceOrderViewModel>(
          builder: (context, placeOrderViewModel, child) {
            return Consumer<CheckoutMethodViewModel>(
              builder: (context, viewModel, child) {
                final shippingMethods =
                    viewModel.shippingMethodUseCase.data?.rows ?? [];
                return !viewModel.shippingMethodUseCase.hasCompleted
                    ? const Center(
                        child: CircularProgressIndicatorWidget(
                          size: Dimens.iconSizeLarge,
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: shippingMethods.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              placeOrderViewModel.setSelectedShippingMethod(
                                  shippingMethods[index]);
                              Navigator.pop(context);
                            },
                            title: Text(shippingMethods[index].name),
                            subtitle: Text(hoursToDaysString(
                                shippingMethods[index].duration)),
                            trailing: SelectionIndicatorWidget(
                              isSelected:
                                  placeOrderViewModel.selectedShippingMethod !=
                                          null &&
                                      placeOrderViewModel
                                              .selectedShippingMethod?.id ==
                                          shippingMethods[index].id,
                            ),
                          );
                        },
                      );
              },
            );
          },
        ),
      ),
    );
  }
}
