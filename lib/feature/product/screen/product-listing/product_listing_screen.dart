import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/product/screen/product-listing/product_listing_view_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/product/product_widget.dart';
import 'package:flamingo/widget/screen/default_screen.dart';
import 'package:flamingo/widget/shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class ProductListingScreen extends StatefulWidget {
  const ProductListingScreen({super.key});

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  final _viewModel = locator<ProductListingViewModel>();

  @override
  void initState() {
    super.initState();
    _viewModel.getProducts('');
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _viewModel,
      builder: (context, child) {
        return DefaultScreen(
          appBarTitle: const Text('Products'),
          scrollable: false,
          child: Consumer<ProductListingViewModel>(
            builder: (context, viewModel, child) {
              final products = viewModel.getProductsUseCase.data?.rows ?? [];
              if (viewModel.getProductsUseCase.isLoading) {
                return const ProductViewShimmerWidget();
              }
              return MasonryGridView.builder(
                mainAxisSpacing: Dimens.spacingSizeSmall,
                crossAxisSpacing: Dimens.spacingSizeSmall,
                itemCount: products.length,
                gridDelegate:
                    const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  return ProductWidget(
                    product: products[index],
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
