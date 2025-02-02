import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/address/screen/address-listing/address_listing_screen.dart';
import 'package:flamingo/feature/auth/auth_view_model.dart';
import 'package:flamingo/feature/cart/data/model/cart_item.dart';
import 'package:flamingo/feature/order/screen/order-listing/order_listing_screen.dart';
import 'package:flamingo/feature/order/screen/place-order/payment_method_selection_screen.dart';
import 'package:flamingo/feature/order/screen/place-order/place_order_view_model.dart';
import 'package:flamingo/feature/order/screen/place-order/shipping_method_selection_screen.dart';
import 'package:flamingo/feature/order/screen/place-order/snippet_checkout_input.dart';
import 'package:flamingo/feature/order/screen/place-order/snippet_order_item.dart';
import 'package:flamingo/shared/constant/payment_method.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/alert-dialog/alert_dialog_widget.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlaceOrderScreen extends StatefulWidget {
  const PlaceOrderScreen({
    Key? key,
    required this.items,
  }) : super(key: key);

  final List<CartItem> items;

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  final _scrollController = ScrollController();
  final _viewModel = locator<PlaceOrderViewModel>();

  @override
  void initState() {
    super.initState();
    _viewModel.setCartItems(widget.items);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _viewModel,
      builder: (context, child) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Consumer<PlaceOrderViewModel>(
            builder: (context, viewModel, child) {
              return DefaultScreen(
                scrollController: _scrollController,
                appBarTitle: const Text('Checkout'),
                bottomNavBarWithButton: true,
                bottomNavBarWithButtonLabel: 'Place Order',
                bottomNavBarWithButtonOnPressed: () {
                  _onPlaceOrder(viewModel);
                },
                isLoading: viewModel.placeOrderUseCase.isLoading,
                // bottomNavigationBar: _buildBottomBar(context),
                child: Column(
                  children: [
                    _buildOrderDetails(),
                    _buildBillingDetails(),
                    _buildDivider(),
                    SnippetCheckoutInput(
                      label: 'Shipping Address',
                      onPressed: () {
                        NavigationHelper.push(
                          context,
                          AddressListingScreen(
                            title: 'Shipping Address',
                            selectedAddressId:
                                viewModel.selectedShippingAddress?.id,
                            onAddressPressed: (address) {
                              viewModel.setSelectedShippingAddress(address);
                              NavigationHelper.pop(context);
                            },
                          ),
                        );
                      },
                      isSet: viewModel.selectedShippingAddress != null,
                      placeholder: 'Select a shipping address',
                      title:
                          '${viewModel.selectedShippingAddress?.name}, ${viewModel.selectedShippingAddress?.area.name}',
                      subtitle:
                          '${viewModel.selectedShippingAddress?.fullName}, ${viewModel.selectedShippingAddress?.mobileNumber}',
                    ),
                    _buildDivider(),
                    // // Billing Address
                    SnippetCheckoutInput(
                      label: 'Billing Address',
                      onPressed: () {
                        NavigationHelper.push(
                          context,
                          AddressListingScreen(
                            title: 'Billing Address',
                            selectedAddressId:
                                viewModel.selectedBillingAddress?.id,
                            onAddressPressed: (address) {
                              viewModel.setSelectedBillingAddress(address);
                              NavigationHelper.pop(context);
                            },
                          ),
                        );
                      },
                      isSet: viewModel.selectedBillingAddress != null,
                      placeholder: 'Select a billing address',
                      title:
                          '${viewModel.selectedBillingAddress?.name}, ${viewModel.selectedBillingAddress?.area.name}',
                      subtitle:
                          '${viewModel.selectedBillingAddress?.fullName}, ${viewModel.selectedBillingAddress?.mobileNumber}',
                    ),
                    _buildDivider(),
                    // Shipping Method
                    SnippetCheckoutInput(
                      label: 'Shipping Method',
                      onPressed: () {
                        NavigationHelper.push(
                          context,
                          ChangeNotifierProvider.value(
                            value: viewModel,
                            builder: (context, child) =>
                                const ShippingMethodSelectionScreen(),
                          ),
                        );
                      },
                      isSet: viewModel.selectedShippingMethod != null,
                      placeholder: 'Select a shipping method',
                      title: viewModel.selectedShippingMethod?.name ?? "",
                    ),
                    _buildDivider(),
                    // Payment Method
                    SnippetCheckoutInput(
                      label: 'Payment Method',
                      onPressed: () {
                        NavigationHelper.push(
                          context,
                          ChangeNotifierProvider.value(
                            value: viewModel,
                            child: const PaymentMethodSelectionScreen(),
                          ),
                        );
                      },
                      isSet: viewModel.selectedPaymentMethod != null,
                      placeholder: 'Select a payment method',
                      title: viewModel.selectedPaymentMethod?.name ?? "",
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: Dimens.spacingSizeDefault),
      child: Divider(
        thickness: 0.5,
      ),
    );
  }

  Widget _buildOrderDetails() {
    return Consumer<PlaceOrderViewModel>(
      builder: (context, viewModel, child) {
        final cartItems = viewModel.items;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'YOUR PRODUCT(S)',
                ),
                Text(
                  ' (${cartItems.length})',
                  style: textTheme(context)
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              constraints:
                  BoxConstraints(maxHeight: SizeConfig.screenHeight * 0.4),
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll) {
                  overscroll.disallowIndicator();
                  return false;
                },
                child: NotificationListener<OverscrollNotification>(
                  onNotification: (OverscrollNotification value) {
                    if (value.overscroll < 0 &&
                        _scrollController.offset + value.overscroll <= 0) {
                      if (_scrollController.offset != 0) {
                        _scrollController.jumpTo(0);
                      }
                      return true;
                    }
                    if (_scrollController.offset + value.overscroll >=
                        _scrollController.position.maxScrollExtent) {
                      if (_scrollController.offset !=
                          _scrollController.position.maxScrollExtent) {
                        _scrollController
                            .jumpTo(_scrollController.position.maxScrollExtent);
                      }
                      return true;
                    }
                    _scrollController
                        .jumpTo(_scrollController.offset + value.overscroll);
                    return true;
                  },
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            bottom: Dimens.spacingSizeDefault),
                        child: SnippetOrderItem(
                          quantity: cartItems[index].quantity,
                          productTitle: cartItems[index].product.title,
                          productVariant: cartItems[index].productVariant,
                          image: extractProductVariantImage(
                            cartItems[index].product.images,
                            cartItems[index].productVariant,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBillingDetails() {
    return Consumer<PlaceOrderViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(
              thickness: 0.5,
            ),
            const SizedBox(height: 5),
            _buildOrderDetailItem(
                title: 'Order Cost', amount: viewModel.subTotal),
            _buildOrderDetailItem(
                title: 'Shipping Fee', amount: viewModel.shippingCost),
            _buildOrderDetailItem(
              title: 'Discount',
              isDiscount: true,
              amount: 0,
            ),
            const Divider(
              thickness: 0.5,
            ),
            const SizedBox(height: 5),
            _buildOrderDetailItem(
              title: 'Total ',
              amount: viewModel.orderTotal,
              boldText: true,
            ),
          ],
        );
      },
    );
  }

  Widget _buildOrderDetailItem({
    required String title,
    required int amount,
    bool boldText = false,
    bool isDiscount = false,
  }) {
    final textStyle = textTheme(context).titleSmall!.copyWith(
          fontWeight: boldText ? FontWeight.bold : null,
        );
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimens.spacingSizeExtraSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: textStyle,
          ),
          Text(
            isDiscount
                ? '-Rs. ${formatNepaliCurrency(amount)}'
                : 'Rs. ${formatNepaliCurrency(amount)}',
            style: textStyle,
          )
        ],
      ),
    );
  }

  _onPlaceOrder(PlaceOrderViewModel viewModel) {
    if (viewModel.selectedShippingAddress == null) {
      showToast(context,
          message: 'Please select a shipping address.', isSuccess: false);
    } else if (viewModel.selectedBillingAddress == null) {
      showToast(context,
          message: 'Please select a billing address.', isSuccess: false);
    } else if (viewModel.selectedShippingMethod == null) {
      showToast(context,
          message: 'Please select a shipping method.', isSuccess: false);
    } else if (viewModel.selectedPaymentMethod == null) {
      showToast(context,
          message: 'Please select a payment method.', isSuccess: false);
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialogWidget(
          title: 'Confirm checkout?',
          needSecondButton: true,
          firstButtonLabel: 'Checkout',
          firstButtonOnPressed: () async {
            // pop confimation dialog
            Navigator.pop(ctx);

            if (viewModel.selectedPaymentMethod!.code == PaymentMethod.KHALTI) {
              await _checkoutWithKhalti(viewModel);
            } else {
              await viewModel.placeOrder();
            }

            if (!context.mounted) return;
            _observeCheckoutResponse(viewModel);
          },
        ),
      );
    }
  }

  Future<void> _checkoutWithKhalti(PlaceOrderViewModel viewModel) async {
    final response = await KhaltiHelper.pay(
      context,
      amount: viewModel.orderTotal,
      productId: viewModel.orderItemIds,
      productName: viewModel.orderItemNames,
      mobileNumber:
          Provider.of<AuthViewModel>(context, listen: false).user!.mobileNumber,
    );
    if (response.success) {
      await viewModel.placeOrder(paymentToken: response.token);
    }
  }

  _observeCheckoutResponse(PlaceOrderViewModel viewModel) {
    if (viewModel.placeOrderUseCase.hasCompleted) {
      NavigationHelper.popUntil(context, 2);
      NavigationHelper.push(context, const OrderListingScreen());
    } else {
      showToast(
        context,
        message: viewModel.placeOrderUseCase.exception,
        isSuccess: false,
      );
    }
  }
}
