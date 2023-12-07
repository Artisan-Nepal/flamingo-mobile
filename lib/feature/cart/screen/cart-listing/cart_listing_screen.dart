import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/cart/screen/cart-listing/cart_listing_view_model.dart';
import 'package:flamingo/feature/cart/screen/cart-listing/snippet_cart_listing_item.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/button/button.dart';
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
        return Stack(
          children: [
            Consumer<CartListingViewModel>(
              builder: (context, viewModel, child) {
                final cartItems = viewModel.cartUseCase.data?.rows ?? [];
                return TitledScreen(
                  scrollable: false,
                  title: 'SHOPPING BAG (2)',
                  child: Column(
                    children: [
                      _buildCartSummary(),
                      Expanded(
                        child: ListView.builder(
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  top: Dimens.spacingSizeSmall),
                              child: SnippetCartListingItem(
                                cartItem: cartItems[index],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            _buildCheckoutButton()
          ],
        );
      },
    );
  }

  Widget _buildCartSummary() {
    return Column(
      children: [
        _buildSummaryItem(title: 'Subtotal', amount: 120000),
        _buildSummaryItem(title: 'Discount', amount: 0, isDiscount: true),
        const VerticalSpaceWidget(height: Dimens.spacingSizeExtraSmall),
        _buildSummaryItem(title: 'Total', amount: 120000, boldText: true),
        const VerticalSpaceWidget(height: Dimens.spacingSizeSmall),
        const Divider(
          height: 1,
        )
      ],
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

  Widget _buildCheckoutButton() {
    return Positioned(
      bottom: Dimens.spacingSizeDefault,
      right: Dimens.spacingSizeDefault,
      left: Dimens.spacingSizeDefault,
      child: FilledButtonWidget(
        label: 'Proceed To Checkout',
        width: SizeConfig.screenWidth - 2 * Dimens.spacingSizeDefault,
        onPressed: () async {},
      ),
    );
  }
}
