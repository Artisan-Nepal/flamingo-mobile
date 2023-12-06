import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/cart/screen/cart-listing/cart_listing_view_model.dart';
import 'package:flamingo/feature/cart/screen/cart-listing/snippet_cart_listing_item.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/button/button.dart';
import 'package:flamingo/widget/screen/screen.dart';
import 'package:flutter/cupertino.dart';
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
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      return SnippetCartListingItem(
                        cartItem: cartItems[index],
                      );
                    },
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
