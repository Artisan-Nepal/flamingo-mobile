import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/order/screen/place-order/checkout_method_view_model.dart';
import 'package:flamingo/feature/order/screen/place-order/place_order_view_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/loader/circular_progress_indicator_widget.dart';
import 'package:flamingo/widget/widget.dart';
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
                    : Wrap(
                        children: List<Widget>.generate(paymentMethods.length,
                            (index) {
                          final isSelected = placeOrderViewModel
                                      .selectedPaymentMethod !=
                                  null &&
                              placeOrderViewModel.selectedPaymentMethod!.id ==
                                  paymentMethods[index].id;
                          return Padding(
                            padding:
                                const EdgeInsets.only(right: Dimens.spacing_8),
                            child: Container(
                              height: 70,
                              padding: const EdgeInsets.symmetric(
                                horizontal: Dimens.spacingSizeDefault,
                                vertical: Dimens.spacingSizeExtraSmall,
                              ),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(Dimens.radiusSmall),
                                color: isSelected
                                    ? AppColors.secondaryLight
                                    : AppColors.white,
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.secondaryMain
                                      : Theme.of(context).disabledColor,
                                  width: 1,
                                ),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  placeOrderViewModel.setSelectedPaymentMethod(
                                      paymentMethods[index]);
                                  Navigator.pop(context);
                                },
                                child: Image.asset(
                                  getPaymentMethodIcon(
                                      paymentMethods[index].code),
                                  // color: selectedIndex == index ? AppColors.secondary_light : null,
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                // : ListView.builder(
                //     padding: EdgeInsets.zero,
                //     itemCount: paymentMethods.length,
                //     itemBuilder: (context, index) {
                //       return ListTile(
                //         onTap: () {
                //           placeOrderViewModel.setSelectedPaymentMethod(
                //               paymentMethods[index]);
                //           Navigator.pop(context);
                //         },
                //         title: Text(paymentMethods[index].name),
                //         trailing: SelectionIndicatorWidget(
                //           isSelected:
                //               placeOrderViewModel.selectedPaymentMethod !=
                //                       null &&
                //                   placeOrderViewModel
                //                           .selectedPaymentMethod!.id ==
                //                       paymentMethods[index].id,
                //         ),
                //       );
                //     },
                //   );
              },
            );
          },
        ),
      ),
    );
  }
}
