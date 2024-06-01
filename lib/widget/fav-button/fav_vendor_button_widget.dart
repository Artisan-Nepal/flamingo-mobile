import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/vendor/favourite_vendor_view_model.dart';
import 'package:flamingo/feature/vendor/update_favourite_vendor_view_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavVendorButtonWidget extends StatefulWidget {
  const FavVendorButtonWidget({
    super.key,
    required this.vendorId,
    this.iconSize = Dimens.iconSize_22,
    this.color = AppColors.secondaryMain,
    this.padding,
    this.enabled = true,
  });

  final String vendorId;
  final double iconSize;
  final Color color;
  final EdgeInsets? padding;
  final bool enabled;
  @override
  State<FavVendorButtonWidget> createState() => _FavVendorButtonWidgetState();
}

class _FavVendorButtonWidgetState extends State<FavVendorButtonWidget> {
  final _updateFavouriteVendorViewModel =
      locator<UpdateFavouriteVendorViewModel>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _updateFavouriteVendorViewModel,
      builder: (context, child) {
        return Consumer<UpdateFavouriteVendorViewModel>(
          builder: (context, updateFavouriteVendorViewModel, child) {
            return Consumer<FavouriteVendorViewModel>(
              builder: (context, viewModel, child) {
                final isFavourited = viewModel.isFavourited(widget.vendorId);
                return GestureDetector(
                  onTap: () {
                    if (widget.enabled) {
                      _onUpdateFavouriteBrand(updateFavouriteVendorViewModel);
                    }
                  },
                  child: Container(
                    color: AppColors.transparent,
                    padding: widget.padding,
                    child: Icon(
                      isFavourited || !widget.enabled
                          ? Icons.favorite
                          : Icons.favorite_outline,
                      size: widget.iconSize,
                      color: widget.enabled
                          ? isFavourited
                              ? AppColors.secondaryMain
                              : AppColors.grayMain
                          : AppColors.grayLight,
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

  Future<void> _onUpdateFavouriteBrand(
      UpdateFavouriteVendorViewModel viewModel) async {
    await viewModel.updateFavouriteVendor(widget.vendorId);
  }
}
