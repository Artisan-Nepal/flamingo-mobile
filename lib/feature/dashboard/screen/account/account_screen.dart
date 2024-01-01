import 'package:flamingo/feature/address/screen/address-listing/address_listing_screen.dart';
import 'package:flamingo/feature/auth/auth.dart';
import 'package:flamingo/feature/auth/auth_view_model.dart';
import 'package:flamingo/feature/cart/screen/cart-listing/cart_listing_screen.dart';
import 'package:flamingo/feature/customer-activity/customer_activity_view_model.dart';
import 'package:flamingo/feature/dashboard/screen/account/snippet_display_picture.dart';
import 'package:flamingo/feature/order/screen/order-listing/order_listing_screen.dart';
import 'package:flamingo/feature/wishlist/screen/wishlist-listing/wishlist_listing_screen.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/alert-dialog/alert_dialog_widget.dart';
import 'package:flamingo/widget/button/button.dart';
import 'package:flamingo/widget/list-tile/list_tile.dart';
import 'package:flamingo/widget/screen/screen.dart';
import 'package:flamingo/widget/space/space.dart';
import 'package:flamingo/widget/text/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final customerActivityViewModel =
        Provider.of<CustomerActivityViewModel>(context);
    return TitledScreen(
      automaticallyImplyAppBarLeading: false,
      title: 'Account',
      appbarActions: const [CartButtonWidget()],
      child: Column(
        children: [
          Center(
            child: SnippetDisplayPicture(),
          ),
          if (authViewModel.hasName) ...[
            VerticalSpaceWidget(
              height: Dimens.spacingSizeDefault,
            ),
            TextWidget(
              getFullName(
                firstName: authViewModel.user?.firstName,
                lastName: authViewModel.user?.lastName,
              ),
              style: textTheme(context).bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
          VerticalSpaceWidget(
            height: Dimens.spacingSizeLarge,
          ),
          ListTileV2Wdiget(
            title: 'Account Setting',
            onPressed: () {
              // NavigationHelper.push(context, const AddProfileScreen());
            },
          ),
          ListTileV2Wdiget(
            title: 'Orders (${customerActivityViewModel.orderCount})',
            onPressed: () {
              NavigationHelper.push(context, const OrderListingScreen());
            },
          ),
          ListTileV2Wdiget(
            title: 'Cart (${customerActivityViewModel.cartCount})',
            onPressed: () {
              NavigationHelper.push(context, const CartListingScreen());
            },
          ),
          ListTileV2Wdiget(
            title: 'Wishlist (${customerActivityViewModel.wishlistCount})',
            onPressed: () {
              NavigationHelper.push(context, const WishlistListingScreen());
            },
          ),
          ListTileV2Wdiget(
            title: 'Address',
            onPressed: () {
              NavigationHelper.push(
                context,
                const AddressListingScreen(
                    showSelectionIndication: false, title: "Addresses"),
              );
            },
          ),
          ListTileV2Wdiget(
            title: 'Log out',
            onPressed: () {
              _onLogout(authViewModel);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _onLogout(AuthViewModel viewModel) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialogWidget(
          title: 'Logout?',
          needSecondButton: true,
          firstButtonLabel: 'Continue',
          secondButtonLabel: 'Cancel',
          firstButtonOnPressed: () async {
            await viewModel.logout();
            if (!context.mounted) return;

            if (viewModel.logoutUseCase.hasCompleted) {
              NavigationHelper.pushAndReplaceAll(context, const LoginScreen());
            } else {
              showToast(
                context,
                message: viewModel.logoutUseCase.exception,
                isSuccess: false,
              );
            }
          },
        );
      },
    );
  }
}
