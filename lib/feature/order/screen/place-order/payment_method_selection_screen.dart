import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/order/screen/place-order/checkout_method_view_model.dart';
import 'package:flamingo/feature/order/screen/place-order/place_order_view_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/loader/circular_progress_indicator_widget.dart';
import 'package:flamingo/widget/screen/default_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentMethodSelectionScreen extends StatefulWidget {
  const PaymentMethodSelectionScreen({Key? key}) : super(key: key);

  @override
  State<PaymentMethodSelectionScreen> createState() =>
      _PaymentMethodSelectionScreenState();
}

class _PaymentMethodSelectionScreenState
    extends State<PaymentMethodSelectionScreen> {
  final _viewModel = locator<CheckoutMethodViewModel>();

  @override
  void initState() {
    super.initState();
    _viewModel.getPaymentMethods();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _viewModel,
      child: DefaultScreen(
        scrollable: false,
        appBarTitle: const Text('Select a payment method'),
        child: Consumer<PlaceOrderViewModel>(
          builder: (context, placeOrderViewModel, child) {
            return Consumer<CheckoutMethodViewModel>(
              builder: (context, viewModel, child) {
                final paymentMethods =
                    viewModel.paymentMethodUseCase.data?.rows ?? [];
                return !viewModel.paymentMethodUseCase.hasCompleted
                    ? const Center(
                        child: CircularProgressIndicatorWidget(
                          size: Dimens.iconSizeLarge,
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: paymentMethods.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              placeOrderViewModel.setSelectedPaymentMethod(
                                  paymentMethods[index]);
                              Navigator.pop(context);
                            },
                            leading: const Icon(
                              Icons.attach_money,
                              color: AppColors.primaryMain,
                            ),
                            title: Text(paymentMethods[index].name),
                            trailing:
                                (placeOrderViewModel.selectedPaymentMethod !=
                                            null &&
                                        placeOrderViewModel
                                                .selectedPaymentMethod!.id ==
                                            paymentMethods[index].id)
                                    ? const Icon(
                                        Icons.check,
                                        color: AppColors.primaryMain,
                                      )
                                    : null,
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
