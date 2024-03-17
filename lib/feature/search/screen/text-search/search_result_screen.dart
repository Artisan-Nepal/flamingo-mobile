import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/feature/product/screen/product-listing/snippet_product_listing.dart';
import 'package:flamingo/feature/search/screen/text-search/search_screen.dart';
import 'package:flamingo/feature/search/screen/text-search/search_view_model.dart';
import 'package:flamingo/feature/search/screen/text-search/snippet_search_history_item.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/error/default_error_widget.dart';
import 'package:flamingo/widget/loader/loader.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchResultScreen extends StatefulWidget {
  const SearchResultScreen({
    super.key,
    required this.keyword,
  });

  final String keyword;

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  final _searchController = SearchController();

  @override
  void initState() {
    _searchController.text = widget.keyword;
    Provider.of<SearchViewModel>(context, listen: false)
        .searchProducts(widget.keyword);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScreen(
      scrollable: false,
      appBarLeadingWidth: 45,
      appBarTitle: Container(
        child: SearchBarFieldWidget(
          controller: _searchController,
          readOnly: true,
          onTap: () {
            NavigationHelper.pushWithoutAnimation(
              context,
              SearchScreen(
                initialText: widget.keyword,
              ),
            );
          },
        ),
      ),
      appBarLeading: Padding(
        padding: const EdgeInsets.only(left: Dimens.spacingSizeDefault),
        child: BackButtonWidget(size: Dimens.iconSize_20),
      ),
      padding: EdgeInsets.zero,
      child: Consumer<SearchViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.searchProductsUseCase.hasError) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                                      errorMessage: 'Sorry, no products found',
                                    )
                                  : Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: Dimens.spacingSizeSmall,
                                        horizontal: Dimens.spacingSizeDefault,
                                      ),
                                      child: SnippetProductListing(
                                        products: products
                                            .map(
                                              (product) => Product(
                                                quantity: product.variants.first
                                                    .quantityInStock,
                                                image:
                                                    extractProductDefaultImage(
                                                  product.images,
                                                  product.variants,
                                                ),
                                                vendorId: product.vendor.id,
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
