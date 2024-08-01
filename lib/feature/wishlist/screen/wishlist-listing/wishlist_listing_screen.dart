import 'package:flamingo/data/model/paginated_option.dart';
import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/auth/auth_view_model.dart';
import 'package:flamingo/feature/customer-activity/customer_activity_view_model.dart';
import 'package:flamingo/feature/wishlist/screen/wishlist-listing/snippet_wishlist_item.dart';
import 'package:flamingo/feature/wishlist/screen/wishlist-listing/wishlist_listing_view_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/error/default_error_widget.dart';
import 'package:flamingo/widget/load-more/load_more_view_model.dart';
import 'package:flamingo/widget/loader/default_screen_loader_widget.dart';
import 'package:flamingo/widget/not-logged-in/not_logged_in_widget.dart';
import 'package:flamingo/widget/refresher/refresher_widget.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class WishlistListingScreen extends StatefulWidget {
  const WishlistListingScreen({super.key});

  @override
  State<WishlistListingScreen> createState() => _WishlistListingScreenState();
}

class _WishlistListingScreenState extends State<WishlistListingScreen> {
  final _viewModel = locator<WishlistListingViewModel>();
  final _loadMoreViewModel = locator<LoadMoreViewModel>();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

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
      create: (context) => _loadMoreViewModel,
      child: ChangeNotifierProvider(
        create: (context) => _viewModel,
        builder: (context, child) {
          return TitledScreen(
            automaticallyImplyAppBarLeading: false,
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
                      final items = viewModel.wishlistUseCase.data?.rows ?? [];
                      return RefresherWidget(
                        controller: _refreshController,
                        enablePullUp: viewModel.wishlistUseCase.hasCompleted &&
                            items.length >= 10,
                        onRefresh: () async {
                          await _viewModel.getWishlist(updateState: false);
                        },
                        onLoadMore: (int page, int limit) async {
                          await viewModel.getWishlist(
                            updateState: false,
                            paginate: true,
                            paginationOption: PaginationOption(
                              page: page,
                              limit: limit,
                            ),
                          );
                          return incrementPage(viewModel.wishlistUseCase);
                        },
                        child: viewModel.wishlistUseCase.hasError
                            ? DefaultErrorWidget(
                                errorMessage:
                                    viewModel.wishlistUseCase.exception!,
                                onActionButtonPressed: () async {
                                  await _viewModel.getWishlist();
                                },
                              )
                            : items.isEmpty
                                ? DefaultErrorWidget(
                                    errorMessage:
                                        'You do not have any products in your wishlist.',
                                  )
                                : GridView.builder(
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
                                  ),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}
