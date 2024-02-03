import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/auth/auth_view_model.dart';
import 'package:flamingo/feature/customer-activity/customer_activity_view_model.dart';
import 'package:flamingo/feature/wishlist/screen/wishlist-listing/snippet_wishlist_item.dart';
import 'package:flamingo/feature/wishlist/screen/wishlist-listing/wishlist_listing_view_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/error/default_error_widget.dart';
import 'package:flamingo/widget/loader/default_screen_loader_widget.dart';
import 'package:flamingo/widget/not-logged-in/not_logged_in_widget.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class WishlistListingScreen extends StatefulWidget {
  const WishlistListingScreen({super.key});

  @override
  State<WishlistListingScreen> createState() => _WishlistListingScreenState();
}

class _WishlistListingScreenState extends State<WishlistListingScreen> {
  final _viewModel = locator<WishlistListingViewModel>();

  @override
  void initState() {
    super.initState();
    _viewModel.getWishlist();
  }

  @override
  Widget build(BuildContext context) {
    final wishlistCount =
        Provider.of<CustomerActivityViewModel>(context).wishlistCount;
    final authViewModel = Provider.of<AuthViewModel>(context);
    return ChangeNotifierProvider(
      create: (context) => _viewModel,
      builder: (context, child) {
        return TitledScreen(
          appbarActions: const [CartButtonWidget()],
          title: 'WISHLIST ($wishlistCount)',
          scrollable: false,
          child: !authViewModel.isLoggedIn
              ? NotLoggedInWidget(
                  title: 'LOOKING FOR YOUR WISHLIST?',
                  message:
                      'Login to view your wishlist and keep your favorite pieces close by')
              : Consumer<WishlistListingViewModel>(
                  builder: (context, viewModel, child) {
                    if (viewModel.wishlistUseCase.isLoading) {
                      return const DefaultScreenLoaderWidget();
                    }
                    if (viewModel.wishlistUseCase.hasError) {
                      return DefaultErrorWidget(
                        errorMessage: viewModel.wishlistUseCase.exception!,
                        onActionButtonPressed: () async {
                          await _viewModel.getWishlist();
                        },
                      );
                    }
                    final items = viewModel.wishlistUseCase.data?.rows ?? [];
                    if (items.isEmpty) {
                      return const DefaultErrorWidget(
                        errorMessage:
                            'You do not have any products in your wishlist.',
                      );
                    }
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 350,
                        mainAxisSpacing: Dimens.spacingSizeSmall,
                        crossAxisSpacing: Dimens.spacingSizeSmall,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return SnippetWishListItem(
                          item: items[index],
                        );
                      },
                    );
                  },
                ),
        );
      },
    );
  }
}
