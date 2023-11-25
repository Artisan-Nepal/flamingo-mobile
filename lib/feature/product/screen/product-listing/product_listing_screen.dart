import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/product/screen/product-listing/product_listing_view_model.dart';
import 'package:flamingo/feature/product/screen/product-listing/snippet_filter_products_bottomsheet.dart';
import 'package:flamingo/feature/product/screen/product-listing/snippet_product_listing.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/screen/default_screen.dart';
import 'package:flamingo/widget/shimmer/shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListingScreen extends StatefulWidget {
  const ProductListingScreen({
    super.key,
    required this.title,
    required this.productListingType,
    this.categoryId,
    this.vendorId,
  });

  final String title;
  final ProductListingType productListingType;
  final String? vendorId;
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

  getData() {
    if (widget.productListingType.isCategory && widget.categoryId != null) {
      _viewModel.getCategoryProducts(widget.categoryId!);
    } else if (widget.productListingType.isVendor && widget.vendorId != null) {
      _viewModel.getVendorProducts(widget.vendorId!);
    } else {
      _viewModel.getProducts();
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
              return SnippetProductListing(products: products);
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