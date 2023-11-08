import 'package:flamingo/feature/dashboard/dashboard.dart';

import 'package:flamingo/feature/dashboard/screen/home/product/productscreen.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/test-data/list_of_categories.dart';
import 'package:flamingo/widget/text/rich_text.dart';
import 'package:flamingo/widget/text/text.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flamingo/test-data/data.dart';
import 'package:flamingo/test-data/product.dart';

class SearchResultScreen extends StatefulWidget {
  final String searchQuery;
  final String category;

  SearchResultScreen({required this.searchQuery, required this.category});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  List<Product> searchResults = [];
  List<String> category_result = [];
  ItemList _itemList = ItemList('');
  @override
  void initState() {
    super.initState();

    category_result = _itemList.items
        .where((item) =>
            item.toLowerCase().contains(widget.searchQuery.toLowerCase()))
        .toList();
    print(category_result);
    // Perform the search
    searchResults = products
        .where((product) =>
            product.name
                .toLowerCase()
                .contains(widget.searchQuery.toLowerCase()) &&
            product.category.toLowerCase() == widget.category.toLowerCase())
        .toList();

    // Filter based on the second priority (product.hash)
    final hashMatches = products.where((product) =>
        product.hash != null &&
        product.hash!.any((hash) =>
            hash.toLowerCase().contains(widget.searchQuery.toLowerCase())) &&
        product.category.toLowerCase() == (widget.category.toLowerCase()));
    searchResults.addAll(hashMatches);

    // Filter based on the third priority (product.brand)
    final brandMatches = products.where((product) =>
        product.brand
            .toLowerCase()
            .contains(widget.searchQuery.toLowerCase()) &&
        product.category.toLowerCase() == (widget.category.toLowerCase()));
    searchResults.addAll(brandMatches);

    // Remove duplicates by converting to a set and back to a list
    searchResults = searchResults.toSet().toList();
    print(searchResults);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results for ${widget.searchQuery}'),
      ),
      body: searchResults.isNotEmpty || category_result.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: ListView.separated(
                itemCount: searchResults.length + category_result.length,
                separatorBuilder: (context, index) {
                  if (index < category_result.length) {
                    return Divider(
                      color:
                          Colors.grey, // Add a slight grey border between items
                      height: 1, // Set the height of the divider
                    );
                  } else {
                    return VerticalSpaceWidget(height: 0);
                  }
                }, // Add spacing
                itemBuilder: (context, index) {
                  if (index < category_result.length) {
                    // Category items
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2), // Adjust padding
                      title: Container(
                        child: createTextWithBoldMatches(
                            category_result[index], widget.searchQuery),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: AppColors.black,
                      ), // Arrow icon
                      onTap: () {
                        print(category_result[index]); //try
                        // When an item is tapped, navigate to ProductScreen and pass the selected item as an argument
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => HomeScreen()
                              // builder: (context) => ProductListScreen(
                              //   selectedItem: category_result[index],
                              //   category: widget.category,
                              // ),
                              ),
                        );
                      },
                    );
                  } else {
                    // Product items
                    final productIndex = index - category_result.length;
                    Product product = searchResults[productIndex];
                    return ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      title: Container(
                        child: createTextWithBoldMatches(
                            product.name, widget.searchQuery),
                      ),
                      subtitle: TextWidget(
                          'Price: \$${product.price.toStringAsFixed(2)}'),
                      leading: Image.network(
                          'https://plus.unsplash.com/premium_photo-1663838903165-f6a2649f5ae4?auto=format&fit=crop&q=80&w=2070&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            )
          : Center(
              child: Text('No matching products found'),
            ),
    );
  }
}
