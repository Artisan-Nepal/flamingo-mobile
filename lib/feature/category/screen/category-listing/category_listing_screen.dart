import 'package:flamingo/feature/category/data/model/product_category.dart';
import 'package:flamingo/feature/product/screen/product-listing/product_listing_screen.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/list-tile/list_tile.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';

class CategoryListingScreen extends StatelessWidget {
  const CategoryListingScreen({
    super.key,
    required this.categories,
    required this.title,
  });

  final List<ProductCategory> categories;
  final String title;

  @override
  Widget build(BuildContext context) {
    return DefaultScreen(
      appBarTitle: Text(title),
      scrollable: false,
      child: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return ListTileV2Wdiget(
            title: categories[index].name,
            onPressed: () {
              NavigationHelper.push(
                context,
                ProductListingScreen(
                  title: title,
                  productListingType: ProductListingType.all,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
