import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/cart/data/model/cart_item.dart';
import 'package:flamingo/feature/cart/screen/cart-listing/cart_listing_view_model.dart';
import 'package:flamingo/feature/cart/update_cart_view_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/button/button.dart';
import 'package:flamingo/widget/image/cached_network_image_widget.dart';
import 'package:flamingo/widget/loader/circular_progress_indicator_widget.dart';
import 'package:flamingo/widget/space/space.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SnippetCartListingItem extends StatefulWidget {
  const SnippetCartListingItem({
    Key? key,
    required this.cartItem,
  }) : super(key: key);

  final CartItem cartItem;

  @override
  State<SnippetCartListingItem> createState() => _SnippetCartListingItemState();
}

class _SnippetCartListingItemState extends State<SnippetCartListingItem> {
  final _viewModel = locator<UpdateCartViewModel>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _viewModel,
      builder: (context, child) {
        return Consumer<UpdateCartViewModel>(
          builder: (context, viewModel, child) {
            return Stack(
              children: [
                Container(
                  color: Colors.transparent,
                  width: double.infinity,
                  padding: const EdgeInsets.all(
                    Dimens.spacingSizeDefault,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 2,
                        child: CachedNetworkImageWidget(
                          image: extractProductVariantImage(
                            widget.cartItem.product.images,
                            widget.cartItem.productVariant,
                          ),
                          needPlaceHolder: true,
                          fit: BoxFit.cover,
                          height: 150,
                        ),
                      ),
                      const HorizontalSpaceWidget(
                          width: Dimens.spacingSizeDefault),
                      Flexible(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // title
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.cartItem.product.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const HorizontalSpaceWidget(
                                    width: Dimens.spacingSizeDefault),

                                // Remove button
                                GestureDetector(
                                  onTap: () {
                                    _onRemove(viewModel);
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    color: AppColors.black,
                                  ),
                                ),
                              ],
                            ),
                            const VerticalSpaceWidget(
                                height: Dimens.spacingSizeExtraSmall),
                            _buildVariantDetails(),
                            const VerticalSpaceWidget(
                                height: Dimens.spacingSizeSmall),
                            _buildQuantityInStock(),
                            const VerticalSpaceWidget(
                                height: Dimens.spacingSizeSmall),
                            _buildQuantityAdjuster(viewModel),
                            const VerticalSpaceWidget(
                                height: Dimens.spacingSizeDefault),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Rs. ${formatNepaliCurrency(widget.cartItem.productVariant.price * widget.cartItem.quantity)}',
                                style: textTheme(context).labelLarge!.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // _buildLoader(viewModel),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildLoader(UpdateCartViewModel viewModel) {
    if (!(viewModel.updateCartUseCase.isLoading ||
        viewModel.removeCartUseCase.isLoading)) {
      return const SizedBox();
    }

    return Positioned.fill(
      child: Container(
        color: themedLoaderBackground(context),
        child: const Align(
          alignment: Alignment.center,
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicatorWidget(),
          ),
        ),
      ),
    );
  }

  Widget _buildVariantDetails() {
    // final attributes = widget.cartItem.productVariant.attributes;
    return Wrap(
      spacing: Dimens.spacingSizeExtraSmall,
      runSpacing: Dimens.spacingSizeExtraSmall,
      children: [
        _buildInfoWrapper(widget.cartItem.productVariant.color.name),
        _buildInfoWrapper(widget.cartItem.productVariant.size.value),
        // ...List<Widget>.generate(
        //   attributes.length,
        //   (index) {
        //     return _buildInfoWrapper(attributes[index].option.value);
        //   },
        // )
      ],
    );
  }

  _buildQuantityInStock() {
    return _buildInfoWrapper(
      'Last ${widget.cartItem.productVariant.quantityInStock} left',
    );
  }

  _buildInfoWrapper(String info) {
    return Container(
      color:
          isLightMode(context) ? AppColors.grayLighter : AppColors.grayDarker,
      padding: const EdgeInsets.symmetric(
        vertical: Dimens.spacingSizeExtraSmall,
        horizontal: Dimens.spacingSizeSmall,
      ),
      child: Text(
        info,
        style: textTheme(context).bodySmall,
      ),
    );
  }

  Widget _buildQuantityAdjuster(UpdateCartViewModel viewModel) {
    return Row(
      children: [
        SmallButtonWidget(
          height: 20,
          width: 20,
          enabled: widget.cartItem.quantity > 1,
          // enabled: widget.cartItem.quantity > 1 &&
          //     !viewModel.updateCartUseCase.isLoading,
          icon: Icons.remove,
          onPressed: () {
            _onDecrement(viewModel);
          },
        ),
        const SizedBox(
          width: 5,
        ),
        Container(
          height: 20,
          width: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            widget.cartItem.quantity.toString(),
            style: TextStyle(
              color: themedPrimaryColor(context),
              fontSize: Dimens.fontSizeLarge,
              // color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        SmallButtonWidget(
          height: 20,
          width: 20,
          // enabled: !viewModel.updateCartUseCase.isLoading,
          icon: Icons.add,
          onPressed: () {
            _onIncrement(viewModel);
          },
        ),
      ],
    );
  }

  _onRemove(UpdateCartViewModel viewModel) async {
    await viewModel.removeFromCart(widget.cartItem.id);
    _obserseRemoveResponse(viewModel);
  }

  _onIncrement(UpdateCartViewModel viewModel) async {
    final updatedQuantity = widget.cartItem.quantity + 1;
    await viewModel.updateCart(widget.cartItem.id, updatedQuantity);
    _obserseUpdateResponse(viewModel, updatedQuantity);
  }

  _onDecrement(UpdateCartViewModel viewModel) async {
    final updatedQuantity = widget.cartItem.quantity - 1;

    await viewModel.updateCart(widget.cartItem.id, updatedQuantity);
    _obserseUpdateResponse(viewModel, updatedQuantity);
  }

  void _obserseUpdateResponse(
      UpdateCartViewModel viewModel, int updatedQuantity) {
    if (viewModel.updateCartUseCase.hasCompleted) {
      Provider.of<CartListingViewModel>(context, listen: false)
          .updateCartQuantity(widget.cartItem.id, updatedQuantity);
    } else {
      showToast(
        context,
        message: viewModel.removeCartUseCase.exception,
        isSuccess: false,
      );
    }
  }

  void _obserseRemoveResponse(UpdateCartViewModel viewModel) {
    if (viewModel.removeCartUseCase.hasCompleted) {
      Provider.of<CartListingViewModel>(context, listen: false)
          .removeFromCartState(widget.cartItem.id);
    } else {
      showToast(
        context,
        message: viewModel.removeCartUseCase.exception,
        isSuccess: false,
      );
    }
  }
}
