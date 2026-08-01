import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/feature/product/data/model/product_detail.dart';
import 'package:flamingo/feature/product/screen/product-listing/product_listing_view_model.dart';
import 'package:flamingo/feature/vendor/data/model/seller.dart';
import 'package:flamingo/feature/vendor/screen/vendor-profile/vendor_profile_screen.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/error/default_error_widget.dart';
import 'package:flamingo/widget/product/product.dart';
import 'package:flamingo/widget/shimmer/shimmer.dart';
import 'package:flamingo/widget/store-avatar/store_avatar_widget.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// New arrivals from every brand the customer follows, one horizontal row per
// brand. Opened from the home "Brands you follow" entry point.
//
// Repeated rows are the right shape *here* in a way they were not on home:
// this is a listing destination where per-brand grouping is the whole point,
// and each row is a different label rather than another arbitrary slice of
// the same catalog.
class FollowedBrandsScreen extends StatefulWidget {
  const FollowedBrandsScreen({super.key});

  @override
  State<FollowedBrandsScreen> createState() => _FollowedBrandsScreenState();
}

class _FollowedBrandsScreenState extends State<FollowedBrandsScreen> {
  final _viewModel = locator<ProductListingViewModel>();

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData({bool isRefresh = false}) async {
    await _viewModel.getProducts(
      isRefresh: isRefresh,
      productType: ProductType.FAVORITE_VENDOR,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _viewModel,
      builder: (context, child) {
        return DefaultScreen(
          appBarTitle: const Text('Brands you follow'),
          scrollable: false,
          padding: EdgeInsets.zero,
          child: Consumer<ProductListingViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.getProductsUseCase.isLoading) {
                return const ProductViewShimmerWidget();
              }
              if (viewModel.getProductsUseCase.hasError) {
                return DefaultErrorWidget(
                  errorMessage: viewModel.getProductsUseCase.exception!,
                  onActionButtonPressed: () async => await getData(),
                );
              }

              final products = viewModel.getProductsUseCase.data?.rows ?? [];
              if (products.isEmpty) {
                return const DefaultErrorWidget(
                  errorMessage:
                      'No new arrivals from the brands you follow yet.',
                );
              }

              // Group by seller, preserving the backend's product order.
              final Map<String, Seller> sellerById = {};
              final Map<String, List<ProductDetail>> productsBySellerId = {};
              for (final product in products) {
                final sellerId = product.seller.id;
                sellerById.putIfAbsent(sellerId, () => product.seller);
                (productsBySellerId[sellerId] ??= []).add(product);
              }
              final brandIds = sellerById.keys.toList();

              return RefreshIndicator.adaptive(
                onRefresh: () async => await getData(isRefresh: true),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      vertical: Dimens.spacingSizeSmall),
                  itemCount: brandIds.length,
                  itemBuilder: (context, index) {
                    final sellerId = brandIds[index];
                    return _BrandRow(
                      seller: sellerById[sellerId]!,
                      products: productsBySellerId[sellerId]!,
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _BrandRow extends StatelessWidget {
  const _BrandRow({required this.seller, required this.products});

  final Seller seller;
  final List<ProductDetail> products;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => NavigationHelper.push(
            context,
            VendorProfileScreen(seller: seller),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimens.spacingSizeSmall,
              vertical: Dimens.spacingSizeSmall,
            ),
            child: Row(
              children: [
                StoreAvatarWidget(
                  name: seller.storeName,
                  imageUrl: seller.displayImageUrl,
                  size: 36,
                ),
                const HorizontalSpaceWidget(width: Dimens.spacingSizeSmall),
                Expanded(
                  child: Text(
                    seller.storeName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme(context).bodyMedium!.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.grayMain,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: SizeConfig.screenWidth,
          height: SizeConfig.screenHeight * 0.32,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) => Container(
              margin: EdgeInsets.only(
                right: Dimens.spacingSizeDefault,
                left: index == 0 ? Dimens.spacingSizeSmall : 0,
              ),
              width: SizeConfig.screenWidth * 0.38,
              child: ProductWidget(
                imageHeight: SizeConfig.screenHeight * 0.22,
                nameMaxLines: 1,
                payload: Product.fromDetail(products[index]),
              ),
            ),
          ),
        ),
        const VerticalSpaceWidget(height: Dimens.spacingSizeLarge),
      ],
    );
  }
}
