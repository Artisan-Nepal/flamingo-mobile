import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/product/screen/product-listing/snippet_product_listing.dart';
import 'package:flamingo/feature/search/screen/search_view_model.dart';
import 'package:flamingo/feature/search/screen/snippet_search_history_item.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/button/variants/text_button_widget.dart';
import 'package:flamingo/widget/error/default_error_widget.dart';
import 'package:flamingo/widget/loader/loader.dart';
import 'package:flamingo/widget/product/product.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();

  final _viewModel = locator<SearchViewModel>();

  @override
  void initState() {
    _viewModel.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _viewModel,
      child: DefaultScreen(
        scrollable: false,
        automaticallyImplyAppBarLeading: false,
        appBarTitle: SearchBarFieldWidget(
          controller: _searchController,
          autofocus: true,
          onSubmitted: (text) {
            if (text != null && text.isNotEmpty) {
              _viewModel.searchProducts(text);
            }
          },
        ),
        appBarActions: [
          TextButtonWidget(
            label: 'Cancel',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            padding: EdgeInsets.zero,
            onPressed: () {
              NavigationHelper.pop(context);
            },
          )
        ],
        padding: EdgeInsets.zero,
        child: Consumer<SearchViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.searchProductsUseCase.hasError) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (viewModel.searchTextHistory.isNotEmpty)
                    _buildSearchHistory(viewModel),
                  Expanded(
                    child: DefaultErrorWidget(
                      errorMessage:
                          viewModel.searchProductsUseCase.exception ?? "",
                    ),
                  ),
                ],
              );
            }
            final products = viewModel.searchProductsUseCase.data ?? [];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (viewModel.searchTextHistory.isNotEmpty)
                  _buildSearchHistory(viewModel),
                Expanded(
                  child: Container(
                    child: viewModel.searchProductsUseCase.isLoading
                        ? const DefaultScreenLoaderWidget(
                            manuallyCenter: true,
                            manualTop: 0.1,
                          )
                        : viewModel.searchProductsUseCase.hasError
                            ? DefaultErrorWidget(
                                manuallyCenter: true,
                                manualTop: 0.1,
                                errorMessage:
                                    viewModel.searchProductsUseCase.exception ??
                                        "",
                              )
                            : !viewModel.searchProductsUseCase.hasCompleted
                                ? const SizedBox()
                                : products.isEmpty
                                    ? DefaultErrorWidget(
                                        manuallyCenter: true,
                                        manualTop: 0.1,
                                        errorMessage:
                                            'Sorry, no products found',
                                      )
                                    : Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: Dimens.spacingSizeDefault,
                                        ),
                                        child: SnippetProductListing(
                                          products: products
                                              .map(
                                                (product) => GenericProduct(
                                                  image: product
                                                      .variants.first.image.url,
                                                  price: product
                                                      .variants.first.price,
                                                  productId: product.id,
                                                  title: product.title,
                                                  vendor:
                                                      product.vendor.storeName,
                                                  product: product,
                                                ),
                                              )
                                              .toList(),
                                          shrinkWrap: false,
                                        ),
                                      ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  _buildSearchHistory(SearchViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const Padding(
        //   padding: EdgeInsets.symmetric(
        //     horizontal: Dimens.spacingSizeDefault,
        //     vertical: Dimens.spacingSizeSmall,
        //   ),
        //   child: Text(
        //     'Search History :',
        //     style: TextStyle(
        //       fontWeight: FontWeight.w600,
        //     ),
        //   ),
        // ),
        Wrap(
          children:
              List<Widget>.generate(viewModel.searchTextHistory.length, (i) {
            int index = viewModel.searchTextHistory.length - 1 - i;
            return SnippetSearchHistoryItem(
              title: viewModel.searchTextHistory[index],
              onTap: () {
                _searchController.text = viewModel.searchTextHistory[index];
                FocusScope.of(context).unfocus();
                viewModel.searchProducts(viewModel.searchTextHistory[index]);
              },
              onCancel: () {
                viewModel
                    .removeSearchedText(viewModel.searchTextHistory[index]);
              },
            );
          }),
        ),
      ],
    );
  }
}
