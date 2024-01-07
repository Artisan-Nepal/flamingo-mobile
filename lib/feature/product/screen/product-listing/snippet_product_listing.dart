import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/product/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SnippetProductListing extends StatelessWidget {
  const SnippetProductListing({
    super.key,
    required this.products,
    this.shrinkWrap = true,
  });

  final List<GenericProduct> products;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.builder(
      mainAxisSpacing: Dimens.spacingSizeSmall,
      crossAxisSpacing: Dimens.spacingSizeSmall,
      itemCount: products.length,
      shrinkWrap: shrinkWrap,
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemBuilder: (context, index) {
        return ProductWidget(
          payload: products[index],
        );
      },
    );
  }
}
