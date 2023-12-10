import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/address/screen/address-listing/address_listing_screen.dart';
import 'package:flamingo/feature/cart/screen/cart-listing/cart_listing_view_model.dart';
import 'package:flamingo/feature/order/screen/place-order/place_order_view_model.dart';
import 'package:flamingo/feature/order/screen/place-order/snippet_checkout_input.dart';
import 'package:flamingo/feature/order/screen/place-order/snippet_order_detail.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlaceOrderScreen extends StatefulWidget {
  const PlaceOrderScreen({Key? key}) : super(key: key);

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  final _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => locator<PlaceOrderViewModel>(),
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
                bottomNavBarWithButtonOnPressed: () {},
                // bottomNavigationBar: _buildBottomBar(context),
                child: Column(
                  children: [
                    SnippetCheckoutInput(
                      label: 'Shipping Address',
                      onPressed: () {
                        NavigationHelper.push(
                          context,
                          AddressListingScreen(
                            onAddressPressed: (address) {
                              viewModel.setSelectedShippingAddress(address);
                            },
                          ),
                        );
                      },
                      isSet: false,
                      placeholder: 'Select a shipping address',
                      value:
                          '${viewModel.selectedShippingAddress?.name}, ${viewModel.selectedShippingAddress?.area.name}',
                    ),
                    _buildDivider(),
                    // // Billing Address
                    SnippetCheckoutInput(
                      label: 'Billing Address',
                      onPressed: () {
                        NavigationHelper.push(
                          context,
                          AddressListingScreen(
                            onAddressPressed: (address) {
                              viewModel.setSelectedBillingAddress(address);
                            },
                          ),
                        );
                      },
                      isSet: false,
                      placeholder: 'Select a billing address',
                      value:
                          '${viewModel.selectedBillingAddress?.name}, ${viewModel.selectedBillingAddress?.area.name}',
                    ),
                    _buildDivider(),
                    // Shipping Method
                    SnippetCheckoutInput(
                      label: 'Shipping Method',
                      onPressed: () {
                        // NavigationHelper.push(
                        //   context,
                        //   AddressListingScreen(
                        //     onAddressPressed: (address) {
                        //       viewModel.setSelectedBillingAddress(address);
                        //     },
                        //   ),
                        // );
                      },
                      isSet: false,
                      placeholder: 'Select a shipping method',
                      value: viewModel.selectedShippingAddress?.name ?? "",
                    ),
                    _buildDivider(),
                    // Payment Method
                    SnippetCheckoutInput(
                      label: 'Payment Method',
                      onPressed: () {
                        // NavigationHelper.push(
                        //   context,
                        //   AddressListingScreen(
                        //     onAddressPressed: (address) {
                        //       viewModel.setSelectedBillingAddress(address);
                        //     },
                        //   ),
                        // );
                      },
                      isSet: false,
                      placeholder: 'Select a payment method',
                      value: viewModel.selectedPaymentMethod?.name ?? "",
                    ),
                    _buildDivider(),
                    _buildOrderDetails(),
                    _buildBillingDetails(),
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
    return Consumer<CartListingViewModel>(
      builder: (context, viewModel, child) {
        final cartItems = viewModel.cartUseCase.data?.rows ?? [];
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
                        child: SnippetOrderDetail(
                          cartItem: cartItems[index],
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
      builder: (context, placeOrderViewModel, child) {
        return Consumer<CartListingViewModel>(
          builder: (context, cartListingViewModel, child) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(
                thickness: 0.5,
              ),
              const SizedBox(height: 5),
              _buildOrderDetailItem(
                  title: 'Order Cost', amount: cartListingViewModel.cartTotal),
              _buildOrderDetailItem(
                  title: 'Shipping Fee',
                  amount:
                      placeOrderViewModel.selectedShippingMethod?.cost ?? 0),
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
                amount: cartListingViewModel.cartTotal,
                boldText: true,
              ),
            ],
          ),
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
}
