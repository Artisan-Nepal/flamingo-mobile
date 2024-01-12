import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/customer-activity/create_activity_view_model.dart';
import 'package:flamingo/feature/product/screen/product-listing/product_listing_view_model.dart';
import 'package:flamingo/feature/product/screen/product-listing/snippet_product_listing.dart';
import 'package:flamingo/feature/vendor/data/model/vendor.dart';
import 'package:flamingo/shared/constant/user_activity_type.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/error/default_error_widget.dart';
import 'package:flamingo/widget/fav-button/fav_vendor_button_widget.dart';
import 'package:flamingo/widget/product/product.dart';
import 'package:flamingo/widget/shimmer/shimmer.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class VendorProfileScreen extends StatefulWidget {
  const VendorProfileScreen({
    super.key,
    required this.vendor,
  });

  final Vendor vendor;

  @override
  State<VendorProfileScreen> createState() => _VendorProfileScreenState();
}

class _VendorProfileScreenState extends State<VendorProfileScreen> {
  final _productListingViewModel = locator<ProductListingViewModel>();

  void initState() {
    super.initState();
    getData();
  }

  logActivity() async {
    await locator<CreateActivityViewModel>().createUserActivity(
      vendorId: widget.vendor.id,
      activityType: UserActivityType.viewVendor,
    );
  }

  getData() async {
    await _productListingViewModel.getVendorProducts(widget.vendor.id);

    if (_productListingViewModel.getProductsUseCase.hasCompleted) {
      await logActivity();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _productListingViewModel,
      child: DefaultScreen(
        padding: EdgeInsets.zero,
        // needAppBar: false,
        appBarTitle: Text(
          widget.vendor.storeName,
          style: textTheme(context).titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        // appBarActions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: Dimens.spacingSizeDefault),
        //     child: FavVendorButtonWidget(
        //       vendorId: widget.vendor.id,
        //       iconSize: Dimens.iconSizeLarge,
        //     ),
        //   ),
        // ],
        scrollable: false,
        child: SafeArea(
          child: Consumer<ProductListingViewModel>(
            builder: (context, viewModel, child) {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        // ClipOval(
                        //   child: CachedNetworkImageWidget(
                        //     placeHolder:
                        //         ImageConstants.displayPicturePlaceHolder,
                        //     image: widget.vendor.displayImage?.url ?? "",
                        //     fit: BoxFit.cover,
                        //     height: SizeConfig.screenHeight * 0.1,
                        //     width: SizeConfig.screenHeight * 0.1,
                        //   ),
                        // ),
                        VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
                        FavVendorButtonWidget(
                          vendorId: widget.vendor.id,
                          iconSize: Dimens.iconSizeLarge,
                        ),
                        VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
                        Text('Liked by 829'),
                        // VerticalSpaceWidget(height: Dimens.spacingSizeLarge),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(
                        //     horizontal: Dimens.spacingSizeDefault,
                        //   ),
                        //   child: Align(
                        //     alignment: Alignment.centerLeft,
                        //     child: Text(
                        //       'Products',
                        //       style: textTheme(context).titleSmall!.copyWith(
                        //             fontWeight: FontWeight.bold,
                        //           ),
                        //     ),
                        //   ),
                        // ),
                        VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
                      ],
                    ),
                  ),
                  _buildProductListing(viewModel)
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProductListing(ProductListingViewModel viewModel) {
    final products = viewModel.sortedProducts;

    if (viewModel.getProductsUseCase.isLoading) {
      return SliverToBoxAdapter(child: const ProductViewShimmerWidget());
    }
    if (viewModel.getProductsUseCase.hasError) {
      return SliverToBoxAdapter(
        child: DefaultErrorWidget(
          manuallyCenter: true,
          errorMessage: viewModel.getProductsUseCase.exception!,
          onActionButtonPressed: () async {
            await getData();
          },
        ),
      );
    }
    if (products.isEmpty) {
      return SliverToBoxAdapter(
        child: const DefaultErrorWidget(
          manuallyCenter: true,
          errorMessage: 'No products available.',
        ),
      );
    }

    return SnippetProductListing(
      useSliver: true,
      products: products
          .map(
            (p) => GenericProduct(
              image: p.images.firstOrNull ?? "",
              price: p.variants.first.price,
              productId: p.id,
              title: p.title,
              vendor: p.vendor.storeName,
            ),
          )
          .toList(),
    );
  }
}
