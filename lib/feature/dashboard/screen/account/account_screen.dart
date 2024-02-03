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
import 'package:flamingo/widget/not-logged-in/not_logged_in_widget.dart';
import 'package:flamingo/widget/screen/screen.dart';
import 'package:flamingo/widget/space/space.dart';
import 'package:flutter/cupertino.dart';
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
    return TitledScreen(
      automaticallyImplyAppBarLeading: false,
      title: (authViewModel.user?.firstName ?? "PROFILE").toUpperCase(),
      appbarActions: const [CartButtonWidget()],
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimens.spacingSizeDefault,
            ),
            child: authViewModel.isLoggedIn
                ? _buildLoggedInComponents()
                : _buildNotLoggedInComponents(),
          ),
          VerticalSpaceWidget(height: Dimens.spacingSizeOverLarge),
          _buildContactUs(),
        ],
      ),
    );
  }

  Widget _buildContactUs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimens.spacingSizeDefault,
          ),
          child: Text(
            'CONTACT US',
            style: TextStyle(
              color: AppColors.primaryMain,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
        Container(
          height: 80,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: AppColors.grayLighter,
              ),
              bottom: BorderSide(
                color: AppColors.grayLighter,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildContactItem(
                  icon: CupertinoIcons.phone,
                  name: 'Phone',
                  onPressed: () async {
                    final url = 'tel:${CommonConstants.contactNumber}';
                    UrlLauncherHelper.launch(url);
                  },
                ),
              ),
              Container(
                width: 1,
                color: AppColors.grayLighter,
              ),
              Expanded(
                child: _buildContactItem(
                  icon: CupertinoIcons.mail,
                  name: 'Email Us',
                  onPressed: () {
                    final url = 'mailto:${CommonConstants.contactEmail}';
                    UrlLauncherHelper.launch(url);
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String name,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        color: AppColors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
            ),
            VerticalSpaceWidget(height: Dimens.spacingSizeExtraSmall),
            Text(
              name,
              style: TextStyle(
                fontSize: Dimens.fontSizeDefault,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotLoggedInComponents() {
    return NotLoggedInWidget(
      title: 'LET\'S GET PERSONAL',
      message: 'Access you Bag & Wishlist on any of your devices',
    );
  }

  Widget _buildLoggedInComponents() {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final customerActivityViewModel =
        Provider.of<CustomerActivityViewModel>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VerticalSpaceWidget(
          height: Dimens.spacingSizeLarge,
        ),
        Center(
          child: SnippetDisplayPicture(),
        ),
        VerticalSpaceWidget(
          height: Dimens.spacingSizeLarge,
        ),
        Text(
          'MY ACCOUNT',
          style: TextStyle(
            color: AppColors.primaryMain,
            fontWeight: FontWeight.w600,
          ),
        ),
        VerticalSpaceWidget(
          height: Dimens.spacingSizeDefault,
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
    );
  }

  Future<void> _onLogout(AuthViewModel viewModel) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialogWidget(
          title: 'Logout?',
          description: 'Are you sure you want to log out?',
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
