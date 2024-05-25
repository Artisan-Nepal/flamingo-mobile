import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/feature/product/screen/product-listing/product_listing_view_model.dart';
import 'package:flamingo/feature/product/screen/product-listing/snippet_filter_products_bottomsheet.dart';
import 'package:flamingo/feature/product/screen/product-listing/snippet_product_listing.dart';
import 'package:flamingo/feature/vendor/data/model/vendor.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/error/default_error_widget.dart';
import 'package:flamingo/widget/screen/default_screen.dart';
import 'package:flamingo/widget/shimmer/shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListingScreen extends StatefulWidget {
  const ProductListingScreen({
    super.key,
    required this.title,
    required this.productType,
    this.categoryId,
    this.vendor,
  });

  final String title;
  final ProductType productType;
  final Vendor? vendor;
  final String? categoryId;

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  final _viewModel = locator<ProductListingViewModel>();

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData({bool isRefresh = false}) async {
    if (widget.productType.isCategory && widget.categoryId != null) {
      await _viewModel.getCategoryProducts(widget.categoryId!,
          isRefresh: isRefresh);
    } else if (widget.productType.isVendor && widget.vendor != null) {
      await _viewModel.getVendorProducts(widget.vendor!.id,
          isRefresh: isRefresh);
    } else {
      await _viewModel.getProducts(
        isRefresh: isRefresh,
        productType: widget.productType,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _viewModel,
      builder: (context, child) {
        return DefaultScreen(
          appBarTitle: Text(widget.title),
          scrollable: false,
          appBarActions: [
            IconButton(
              onPressed: _onPressFilter,
              icon: const Icon(Icons.filter_list),
            )
          ],
          child: Consumer<ProductListingViewModel>(
            builder: (context, viewModel, child) {
              final products = viewModel.sortedProducts;
              if (viewModel.getProductsUseCase.isLoading) {
                return const ProductViewShimmerWidget();
              }
              if (viewModel.getProductsUseCase.hasError) {
                return DefaultErrorWidget(
                  errorMessage: viewModel.getProductsUseCase.exception!,
                  onActionButtonPressed: () async {
                    await getData();
                  },
                );
              }
              if (products.isEmpty) {
                return const DefaultErrorWidget(
                  errorMessage: 'No products available.',
                );
              }
              return RefreshIndicator.adaptive(
                child: SnippetProductListing(
                  products: products
                      .map(
                        (product) => Product(
                          quantity: product.variants.first.quantityInStock,
                          image: extractProductDefaultImage(
                            product.images,
                            product.variants,
                          ),
                          price: product.variants.first.price,
                          productId: product.id,
                          title: product.title,
                          vendor: product.seller.vendor!.storeName,
                          product: product,
                        ),
                      )
                      .toList(),
                ),
                onRefresh: () async {
                  await getData(isRefresh: true);
                },
              );
            },
          ),
        );
      },
    );
  }

  void _onPressFilter() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Wrap(
        children: [
          Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: ChangeNotifierProvider.value(
              value: _viewModel,
              child: const SnippetFilterProductsBottomSheet(),
            ),
          )
        ],
      ),
    );
  }
}
