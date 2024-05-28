import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/customer-activity/create_activity_view_model.dart';
import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/feature/product/screen/product-listing/product_listing_view_model.dart';
import 'package:flamingo/feature/product/screen/product-listing/snippet_product_listing.dart';
import 'package:flamingo/feature/vendor/data/model/seller.dart';
import 'package:flamingo/feature/vendor/favourite_vendor_view_model.dart';
import 'package:flamingo/feature/vendor/screen/vendor-profile/vendor_profile_view_model.dart';
import 'package:flamingo/shared/constant/user_activity_type.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/error/default_error_widget.dart';
import 'package:flamingo/widget/fav-button/fav_vendor_button_widget.dart';
import 'package:flamingo/widget/image/cached_network_image_widget.dart';
import 'package:flamingo/widget/shimmer/shimmer.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class VendorProfileScreen extends StatefulWidget {
  const VendorProfileScreen({
    super.key,
    required this.seller,
  });

  final Seller seller;

  @override
  State<VendorProfileScreen> createState() => _VendorProfileScreenState();
}

class _VendorProfileScreenState extends State<VendorProfileScreen> {
  final _productListingViewModel = locator<ProductListingViewModel>();
  final _viewModel = locator<VendorProfileViewModel>();

  void initState() {
    super.initState();
    getData();
  }

  logActivity() async {
    await locator<CreateActivityViewModel>().createUserActivity(
      sellerId: widget.seller.id,
      activityType: UserActivityType.viewVendor,
    );
  }

  getData() async {
    await _viewModel.getVendorBySellerId(widget.seller.id);
    if (_viewModel.vendorUseCase.hasCompleted) {
      final vendor = _viewModel.vendorUseCase.data!;
      locator<FavouriteVendorViewModel>().getVendorLikes(vendor.id);
    }

    await _productListingViewModel.getSellerProducts(widget.seller.id);

    if (_productListingViewModel.getProductsUseCase.hasCompleted) {
      await logActivity();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => _productListingViewModel,
        ),
        ChangeNotifierProvider(
          create: (context) => _viewModel,
        )
      ],
      child: DefaultScreen(
        padding: EdgeInsets.zero,
        // needAppBar: false,
        appBarTitle: Text(
          widget.seller.storeName,
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
            builder: (context, productListingViewModel, child) {
              return CustomScrollView(
                slivers: [
                  Consumer<VendorProfileViewModel>(
                      builder: (context, viewModel, child) {
                    return SliverToBoxAdapter(
                      child: Column(
                        children: [
                          if (widget.seller.displayImageUrl != null) ...[
                            VerticalSpaceWidget(
                                height: Dimens.spacingSizeDefault),
                            ClipOval(
                              child: CachedNetworkImageWidget(
                                placeHolder:
                                    ImageConstants.displayPicturePlaceHolder,
                                image: widget.seller.displayImageUrl ?? "",
                                fit: BoxFit.cover,
                                height: SizeConfig.screenHeight * 0.1,
                                width: SizeConfig.screenHeight * 0.1,
                              ),
                            ),
                          ],
                          VerticalSpaceWidget(
                              height: Dimens.spacingSizeDefault),
                          FavVendorButtonWidget(
                            vendorId: viewModel.vendorUseCase.data?.id ?? '',
                            iconSize: Dimens.iconSizeLarge,
                            enabled: viewModel.vendorUseCase.hasCompleted,
                          ),
                          VerticalSpaceWidget(
                              height: Dimens.spacingSizeDefault),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Liked by '),
                              Consumer<FavouriteVendorViewModel>(
                                builder:
                                    (context, favouriteVendorViewModel, child) {
                                  final likes = favouriteVendorViewModel
                                      .getVendorLikeCount(
                                    viewModel.vendorUseCase.data?.id ?? '',
                                  );
                                  return Text(likes.toString());
                                },
                              ),
                            ],
                          ),
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
                          VerticalSpaceWidget(
                              height: Dimens.spacingSizeDefault),
                        ],
                      ),
                    );
                  }),
                  _buildProductListing(productListingViewModel)
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
            (p) => Product(
              quantity: p.variants.first.quantityInStock,
              image: extractProductDefaultImage(
                p.images,
                p.variants,
              ),
              price: p.variants.first.price,
              productId: p.id,
              title: p.title,
              sellerStoreName: p.seller.storeName,
            ),
          )
          .toList(),
    );
  }
}
