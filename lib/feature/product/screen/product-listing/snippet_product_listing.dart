import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/product/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SnippetProductListing extends StatelessWidget {
  const SnippetProductListing({
    super.key,
    required this.products,
  });

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.builder(
      mainAxisSpacing: Dimens.spacingSizeSmall,
      crossAxisSpacing: Dimens.spacingSizeSmall,
      itemCount: products.length,
      shrinkWrap: true,
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemBuilder: (context, index) {
        return ProductWidget(
          product: products[index],
        );
      },
    );
  }
}
