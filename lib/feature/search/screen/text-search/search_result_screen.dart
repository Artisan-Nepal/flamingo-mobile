import 'package:flamingo/feature/category/screen/category-search/category_search_screen.dart';
import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/feature/product/screen/product-listing/snippet_product_listing.dart';
import 'package:flamingo/feature/search/screen/text-search/search_screen.dart';
import 'package:flamingo/feature/search/screen/text-search/search_view_model.dart';
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
      appBarTitle: SearchBarFieldWidget(
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
                                      actionButtonLabel: 'Browse Categories',
                                      onActionButtonPressed: () {
                                        NavigationHelper.push(
                                          context,
                                          const CategorySearchScreen(),
                                        );
                                      },
                                    )
                                  : Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: Dimens.spacingSizeSmall,
                                        horizontal: Dimens.spacingSizeSmall,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Confirms the query actually
                                          // matched something and how much,
                                          // instead of dropping straight into
                                          // an unlabelled grid.
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: Dimens.spacingSizeExtraSmall,
                                              bottom: Dimens.spacingSizeSmall,
                                            ),
                                            child: Text(
                                              '${products.length} ${products.length == 1 ? 'result' : 'results'} for "${widget.keyword}"',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: textTheme(context)
                                                  .bodySmall!
                                                  .copyWith(
                                                    color: AppColors.grayMain,
                                                  ),
                                            ),
                                          ),
                                          Expanded(
                                            child: SnippetProductListing(
                                              padding: 0,
                                              products: products
                                                  .map(Product.fromDetail)
                                                  .toList(),
                                              shrinkWrap: false,
                                            ),
                                          ),
                                        ],
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

}
