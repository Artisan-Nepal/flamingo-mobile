import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/shared/enum/lead_source.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/product/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SnippetProductListing extends StatelessWidget {
  const SnippetProductListing({
    super.key,
    required this.products,
    this.needFavIcon = true,
    this.shrinkWrap = true,
    this.useSliver = false,
    this.padding = Dimens.spacingSizeDefault,
    this.leadSource,
    this.advertisementId,
  });

  final List<Product> products;
  final bool shrinkWrap;
  final bool useSliver;
  final double padding;
  final LeadSource? leadSource;
  final String? advertisementId;
  final bool needFavIcon;

  @override
  Widget build(BuildContext context) {
    if (useSliver)
      return SliverMasonryGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Padding(
              padding: EdgeInsets.only(
                left: index % 2 == 0 ? padding : 0,
                right: index % 2 != 0 ? padding : 0,
              ),
              child: ProductWidget(
                payload: products[index],
                advertisementId: advertisementId,
                leadSource: leadSource,
              ),
            );
          },
          childCount: products.length,
        ),
        mainAxisSpacing: Dimens.spacingSizeSmall,
        crossAxisSpacing: Dimens.spacingSizeSmall,
        gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
      );

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
          advertisementId: advertisementId,
          leadSource: leadSource,
        );
      },
    );
  }
}
