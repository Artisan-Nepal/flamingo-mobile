import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/category/data/model/model.dart';
import 'package:flamingo/feature/dashboard/screen/home/product/product_list_screenmodel.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/test-data/product.dart';
import 'package:flamingo/widget/screen/default_screen.dart';
import 'package:flamingo/widget/space/space.dart';
import 'package:flamingo/widget/text/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatefulWidget {
  final String selectedItem;
  final String category;
  final ProductCategory? productCategory;

  ProductListScreen({
    required this.selectedItem,
    required this.category,
    required this.productCategory,
  });

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _viewmodel = locator<ProductListScreenModel>();
  List<Product> selectedProducts = [];

  @override
  void initState() {
    _viewmodel.gettoplevelCategoriesfromgivencategory(widget.productCategory!);
    super.initState();

    // Place any initialization logic here if needed
  }

  subcat(ProductCategory category) {
    _viewmodel.setSelectedTopLevelCategory(category);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _viewmodel,
      builder: (context, child) => DefaultScreen(
        appBarTitle: TextWidget(
          widget.selectedItem,
          style: TextStyle(fontSize: 20),
        ),
        bottomNavigationBar: const VerticalSpaceWidget(height: 2),
        child: SafeArea(
          child: Consumer<ProductListScreenModel>(
            builder: (context, viewModel, child) {
              if (viewModel.topLevelCategoriesUseCase.isLoading) {
                return const CircularProgressIndicator.adaptive();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: ListView.separated(
                      itemCount: _viewmodel
                              .topLevelCategoriesWithChildren.length +
                          _viewmodel.topLevelCategoriesWithoutChildren.length,
                      separatorBuilder: (context, index) {
                        if (index <
                            _viewmodel.topLevelCategoriesWithChildren.length +
                                _viewmodel
                                    .topLevelCategoriesWithoutChildren.length) {
                          return Divider(
                            color: Colors
                                .grey, // Add a slight grey border between items
                            height: 1, // Set the height of the divider
                          );
                        } else {
                          return VerticalSpaceWidget(height: 0);
                        }
                      }, // Add spacing
                      itemBuilder: (context, index) {
                        if (index <
                            _viewmodel
                                .topLevelCategoriesWithoutChildren.length) {
                          // Category items
                          return AnimatedOpacity(
                              opacity: 1,
                              duration: const Duration(milliseconds: 500),
                              child: _buildSelection(
                                title: widget.selectedItem,
                                categories: _viewmodel
                                    .topLevelCategoriesWithoutChildren[index],
                              ));
                        } else {
                          return AnimatedOpacity(
                              opacity: 1,
                              duration: const Duration(milliseconds: 500),
                              child: _buildSelection(
                                title: widget.selectedItem,
                                categories: _viewmodel
                                        .topLevelCategoriesWithChildren[
                                    index -
                                        _viewmodel
                                            .topLevelCategoriesWithoutChildren
                                            .length],
                              ));
                        }
                      },
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSelection({
    required String title,
    required ProductCategory categories,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          onTap: () {
            subcat(categories);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProductListScreen(
                  selectedItem: categories.name,
                  category: widget.category,
                  productCategory: _viewmodel.selectedTopLevelCategory,
                ),
              ),
            );
          },
          title: TextWidget(
            categories.name,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: AppColors.black,
            ),
          ),
          trailing: const Icon(Icons.keyboard_arrow_right_sharp),
        ),
      ],
    );
  }
}
