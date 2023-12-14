import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/cart/screen/cart-listing/cart_listing_view_model.dart';
import 'package:flamingo/feature/cart/screen/cart-listing/snippet_cart_listing_item.dart';
import 'package:flamingo/feature/order/screen/place-order/place_order_screen.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/button/button.dart';
import 'package:flamingo/widget/loader/circular_progress_indicator_widget.dart';
import 'package:flamingo/widget/screen/screen.dart';
import 'package:flamingo/widget/space/space.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartListingScreen extends StatefulWidget {
  const CartListingScreen({super.key});

  @override
  State<CartListingScreen> createState() => _CartListingScreenState();
}

class _CartListingScreenState extends State<CartListingScreen> {
  final _viewModel = locator<CartListingViewModel>();

  @override
  void initState() {
    super.initState();
    _viewModel.getCart();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _viewModel,
      builder: (context, child) {
        return Consumer<CartListingViewModel>(
          builder: (context, viewModel, child) {
            final cartItems = viewModel.cartUseCase.data?.rows ?? [];
            return TitledScreen(
              scrollable: false,
              padding: EdgeInsets.zero,
              title: 'SHOPPING BAG (2)',
              child: !viewModel.cartUseCase.hasCompleted
                  ? _buildLoader()
                  : Stack(
                      children: [
                        Column(
                          children: [
                            _buildCartSummary(viewModel),
                            Expanded(
                              child: ListView.builder(
                                itemCount: cartItems.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      top: index == 0
                                          ? Dimens.spacingSizeSmall
                                          : 0,
                                      bottom: index == cartItems.length - 1
                                          ? 80
                                          : 0,
                                    ),
                                    child: SnippetCartListingItem(
                                      cartItem: cartItems[index],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        _buildCheckoutButton(viewModel)
                      ],
                    ),
            );
          },
        );
      },
    );
  }

  Widget _buildLoader() {
    return const Padding(
      padding: EdgeInsets.only(bottom: Dimens.spacing_64),
      child: Center(
        child: CircularProgressIndicatorWidget(
          size: Dimens.iconSizeLarge,
        ),
      ),
    );
  }

  Widget _buildCartSummary(CartListingViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(
        left: Dimens.spacingSizeDefault,
        right: Dimens.spacingSizeDefault,
        top: Dimens.spacingSizeDefault,
      ),
      child: Column(
        children: [
          // _buildSummaryItem(title: 'Subtotal', amount: 120000),
          // _buildSummaryItem(title: 'Discount', amount: 0, isDiscount: true),
          // const VerticalSpaceWidget(height: Dimens.spacingSizeExtraSmall),
          _buildSummaryItem(
              title: 'Total', amount: viewModel.cartTotal, boldText: true),
          const VerticalSpaceWidget(height: Dimens.spacingSizeSmall),
          const Divider(
            height: 1,
          )
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required String title,
    required int amount,
    bool boldText = false,
    bool isDiscount = false,
  }) {
    final textStyle = textTheme(context).titleSmall!.copyWith(
          fontWeight: boldText ? FontWeight.bold : null,
        );
    return Row(
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
    );
  }

  Widget _buildCheckoutButton(CartListingViewModel viewModel) {
    return Positioned(
      bottom: Dimens.spacingSizeDefault,
      right: Dimens.spacingSizeDefault,
      left: Dimens.spacingSizeDefault,
      child: FilledButtonWidget(
        label: 'Proceed To Checkout',
        width: SizeConfig.screenWidth - 2 * Dimens.spacingSizeDefault,
        onPressed: () {
          NavigationHelper.push(
            context,
            ChangeNotifierProvider.value(
              value: viewModel,
              builder: (context, child) {
                return PlaceOrderScreen(
                  items: viewModel.cartUseCase.data?.rows ?? [],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
