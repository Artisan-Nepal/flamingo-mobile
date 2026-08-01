import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/shared/enum/lead_source.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/product/product.dart';
import 'package:flutter/material.dart';

// A uniform 2-column grid - every cell the same fixed height and image size,
// regardless of a product's title length or discount state. Used everywhere
// a product grid appears: category/listing screens, search results,
// product-detail related products, vendor profiles.
//
// Previously a masonry grid (flutter_staggered_grid_view), which packed each
// column independently - as card heights varied with content, the two
// columns drifted out of alignment ("up and down" look). Changed to a fixed
// mainAxisExtent grid by design decision (2026-07-27) to match the uniform
// card sizing already used on the home rails (Most wanted, New in). A
// shorter card just carries a little blank space at the bottom of its cell
// rather than the grid re-packing around it.
class SnippetProductListing extends StatelessWidget {
  const SnippetProductListing({
    super.key,
    required this.products,
    this.needFavIcon = true,
    this.shrinkWrap = true,
    this.useSliver = false,
    this.padding = Dimens.spacingSizeSmall,
    this.leadSource,
    this.advertisementId,
    this.onProductTap,
    this.physics,
  });

  final List<Product> products;
  final bool shrinkWrap;
  final bool useSliver;
  final double padding;
  final LeadSource? leadSource;
  final String? advertisementId;
  final bool needFavIcon;
  final void Function(Product product)? onProductTap;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    // Generous enough for the worst case (a 2-line title, seller name, and
    // discount price row) - see ProductWidget. Shorter cards just leave a
    // little blank space rather than risking overflow on longer ones.
    final imageHeight = SizeConfig.screenHeight * 0.25;
    final cellHeight = SizeConfig.screenHeight * 0.42;

    if (useSliver)
      return SliverPadding(
        padding: EdgeInsets.only(
          left: padding,
          right: padding,
        ),
        sliver: SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return _buildProductWidget(products[index], imageHeight);
            },
            childCount: products.length,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: Dimens.spacingSizeSmall,
            crossAxisSpacing: Dimens.spacingSizeSmall,
            mainAxisExtent: cellHeight,
          ),
        ),
      );

    return GridView.builder(
      padding: EdgeInsets.only(
        left: padding,
        right: padding,
      ),
      itemCount: products.length,
      shrinkWrap: shrinkWrap,
      physics: physics,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: Dimens.spacingSizeSmall,
        crossAxisSpacing: Dimens.spacingSizeSmall,
        mainAxisExtent: cellHeight,
      ),
      itemBuilder: (context, index) {
        return _buildProductWidget(products[index], imageHeight);
      },
    );
  }

  Widget _buildProductWidget(Product product, double imageHeight) {
    return ProductWidget(
      payload: product,
      imageHeight: imageHeight,
      advertisementId: advertisementId,
      leadSource: leadSource,
      needFavIcon: needFavIcon,
      onTap: () {
        if (onProductTap != null) {
          onProductTap!(product);
        }
      },
    );
  }
}
