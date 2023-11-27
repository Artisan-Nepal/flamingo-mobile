import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/wishlist/screen/wishlist-listing/snippet_wishlist_item.dart';
import 'package:flamingo/feature/wishlist/screen/wishlist-listing/wishlist_listing_view_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/shimmer/shimmer.dart';
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
    return ChangeNotifierProvider(
      create: (context) => _viewModel,
      builder: (context, child) {
        return TitledScreen(
          title: 'WISHLIST (5)',
          scrollable: false,
          child: Consumer<WishlistListingViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.wishlistUseCase.isLoading) {
                return const ProductViewShimmerWidget();
              }
              final items = viewModel.wishlistUseCase.data?.rows ?? [];
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
