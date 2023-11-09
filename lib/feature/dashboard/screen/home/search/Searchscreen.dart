import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/category/data/model/product_category.dart';
import 'package:flamingo/feature/dashboard/screen/home/product/category/category_list_screen.dart';
import 'package:flamingo/feature/dashboard/screen/home/search/searchscreen_model.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/cards/snippetcard.dart';
import 'package:flamingo/widget/search-bar/search_bar.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _viewmodel = locator<SearchScreenModel>();
  int selectedOptionIndex = 0;
  String selected_value = '';

  subcat(ProductCategory productCategory) {
    _viewmodel.setSelectedCategory(productCategory);
  }

  @override
  void initState() {
    super.initState();
    _viewmodel.initProductAddition();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _viewmodel,
      builder: (context, child) => DefaultScreen(
          appBarTitle: const TextWidget(
            'Search',
            style: TextStyle(fontSize: 20),
          ),
          bottomNavigationBar: const VerticalSpaceWidget(height: 2),
          child: SafeArea(child: Consumer<SearchScreenModel>(
            builder: (context, viewModel, child) {
              if (viewModel.topLevelCategoriesUseCase.isLoading) {
                return const CircularProgressIndicator.adaptive();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Search_Bar(
                    category: selected_value,
                  ),
                  _buildSelection(
                    flag: true,
                    title: 'Category',
                    categories: viewModel.topLevelCategoriesUseCase.data!,
                    selectedCategory: viewModel.selectedTopLevelCategory,
                    onSelection: (category) {
                      viewModel.setSelectedTopLevelCategory(category);
                      _viewmodel.setSelectedTopLevelCategory(category);
                    },
                  ),
                  const VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
                  AnimatedOpacity(
                    opacity: viewModel.selectedTopLevelCategory != null ? 1 : 0,
                    duration: const Duration(milliseconds: 500),
                    child: _buildSelection(
                      flag: false,
                      title: 'Sub-Category',
                      categories:
                          viewModel.selectedTopLevelCategory?.children ?? [],
                      selectedCategory: viewModel.selectedCategory,
                      onSelection: (category) {
                        viewModel.setSelectedCategory(category);
                      },
                    ),
                  ),
                ],
              );
            },
          ))),
    );
  }

  Widget _buildSelection({
    required bool flag,
    required String title,
    required List<ProductCategory> categories,
    required ProductCategory? selectedCategory,
    required Function(ProductCategory category) onSelection,
  }) {
    //ya actual chaiyeko categories auchan
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (categories.isNotEmpty) ...[
          //list ...
          TextWidget(
            title,
            style: textTheme(context).titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
        const VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
        flag
            ? _buildGrid(
                itemBuilder: (context, index) => SnippetCategorySelectionCard(
                  name: categories[index].name,
                  isSelected: selectedCategory == null
                      ? false
                      : selectedCategory.id == categories[index].id,
                  onPressed: () {
                    //yo chalcha
                    onSelection(categories[index]);
                  },
                ),
                itemCount: categories.length,
              )
            : _buildList(
                productCategory: categories,
                itemBuilder: (context, index) => SnippetCategorySelectionCard(
                  name: categories[index].name,
                  isSelected: selectedCategory == null
                      ? false
                      : selectedCategory.id == categories[index].id,
                  onPressed: () {
                    //yo chaldaina
                  },
                ),
                itemCount: categories.length,
              ),
      ],
    );
  }

  Widget _buildGrid({
    required Widget Function(BuildContext, int) itemBuilder,
    required int itemCount,
  }) {
    return MasonryGridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      itemCount: itemCount,
      itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(
            bottom: Dimens.spacingSizeSmall,
            left: index % 2 == 0 ? 0 : Dimens.spacingSizeSmall / 2,
            right: index % 2 == 0 ? Dimens.spacingSizeSmall / 2 : 0,
          ),
          child: itemBuilder(context, index)),
    );
  }

  Widget _buildList({
    required List<ProductCategory> productCategory,
    required Widget Function(BuildContext, int) itemBuilder,
    required int itemCount,
  }) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final item = itemBuilder(context, index); // Get the widget
        String itemName = '';
        if (item is SnippetCategorySelectionCard) {
          itemName = item.name;
        }
        return ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          onTap: () {
            subcat(productCategory[index]);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CategoryListScreen(
                  selectedItem: itemName,
                  category: selected_value,
                  productCategory: _viewmodel.selectedCategory,
                ),
              ),
            );
          },
          title: TextWidget(
            itemName,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: AppColors.black,
            ),
          ),
          trailing: const Icon(Icons.keyboard_arrow_right_sharp),
        );
      },
    );
  }
}
