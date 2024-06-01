import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/wishlist/update_wishlist_view_model.dart';
import 'package:flamingo/feature/wishlist/wishlist_view_model.dart';
import 'package:flamingo/shared/enum/lead_source.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavProductButtonWidget extends StatefulWidget {
  const FavProductButtonWidget({
    super.key,
    required this.productId,
    this.iconSize = Dimens.iconSize_22,
    this.leadSource,
    this.advertisementId,
    this.padding,
  });

  final String productId;
  final double iconSize;
  final LeadSource? leadSource;
  final String? advertisementId;
  final EdgeInsets? padding;

  @override
  State<FavProductButtonWidget> createState() => _FavProductButtonWidgetState();
}

class _FavProductButtonWidgetState extends State<FavProductButtonWidget> {
  final _updateWishlistViewModel = locator<UpdateWishlistViewModel>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _updateWishlistViewModel,
      builder: (context, child) {
        return Consumer<UpdateWishlistViewModel>(
          builder: (context, updateWishlistViewModel, child) {
            return Consumer<WishlistViewModel>(
              builder: (context, wishlistViewModel, child) {
                final isInWishlist =
                    wishlistViewModel.isInWishlist(widget.productId);
                return GestureDetector(
                  onTap: () {
                    _onUpdateWishlist(updateWishlistViewModel);
                  },
                  child: Container(
                    padding: widget.padding,
                    color: AppColors.transparent,
                    child: Icon(
                      isInWishlist ? Icons.favorite : Icons.favorite_outline,
                      size: widget.iconSize,
                      color: isInWishlist
                          ? AppColors.secondaryMain
                          : AppColors.grayMain,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<void> _onUpdateWishlist(UpdateWishlistViewModel viewModel) async {
    await viewModel.updateWishlist(
      widget.productId,
      leadSource: widget.leadSource,
      advertisementId: widget.advertisementId,
    );
  }
}
