import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/product/screen/product-detail/product_detail_screen.dart';
import 'package:flamingo/feature/wishlist/data/model/wishlist_item.dart';
import 'package:flamingo/feature/wishlist/screen/wishlist-listing/wishlist_listing_view_model.dart';
import 'package:flamingo/feature/wishlist/update_wishlist_view_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/image/image.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SnippetWishListItem extends StatefulWidget {
  const SnippetWishListItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  final WishlistItem item;

  @override
  State<SnippetWishListItem> createState() => _SnippetWishListItemState();
}

class _SnippetWishListItemState extends State<SnippetWishListItem> {
  final _updateWishlistViewModel = locator<UpdateWishlistViewModel>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _updateWishlistViewModel,
      builder: (context, child) => GestureDetector(
        onTap: () {
          _navigateToProductDetail(context);
        },
        child: Container(
          color: Colors.transparent,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CachedNetworkImageWidget(
                        image: extractProductDefaultImage(
                          widget.item.product.images,
                          widget.item.product.variants,
                        ),
                        needPlaceHolder: false,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Consumer<UpdateWishlistViewModel>(
                        builder: (context, viewModel, child) {
                          if (viewModel.updateWishlistUseCase.isLoading) {
                            return const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator.adaptive(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.black,
                                ),
                              ),
                            );
                          }
                          return GestureDetector(
                            onTap: () {
                              _onRemove(viewModel);
                            },
                            child: const Icon(
                              Icons.close,
                              color: AppColors.black,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const VerticalSpaceWidget(height: Dimens.spacingSizeExtraSmall),

              TextWidget(
                widget.item.product.seller.storeName,
                style: textTheme(context).bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextWidget(
                widget.item.product.title,
                style: textTheme(context).bodyMedium!,
              ),
              TextWidget(
                'Rs. ${formatNepaliCurrency(widget.item.product.variants.first.price)}',
                style: textTheme(context).labelLarge!,
              ),
              const SizedBox(height: Dimens.spacingSizeExtraSmall),
              OutlinedButtonWidget(
                label: 'Add to bag',
                height: 40,
                fontSize: Dimens.fontSizeDefault,
                onPressed: () {
                  _navigateToProductDetail(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToProductDetail(BuildContext context) {
    NavigationHelper.push(
      context,
      ProductDetailScreen(
        productId: widget.item.id,
        product: widget.item.product,
        title: widget.item.product.title,
      ),
    );
  }

  Future<void> _onRemove(UpdateWishlistViewModel viewModel) async {
    await viewModel.updateWishlist(widget.item.product.id);
    if (!context.mounted) return;

    if (viewModel.updateWishlistUseCase.hasCompleted) {
      Provider.of<WishlistListingViewModel>(context, listen: false)
          .removeFromWishlistState(widget.item.product.id);
    } else {
      showToast(
        context,
        message: viewModel.updateWishlistUseCase.exception,
        isSuccess: false,
      );
    }
  }
}
