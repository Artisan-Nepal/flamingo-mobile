import 'package:flamingo/feature/category/screen/category-search/category_search_screen.dart';
import 'package:flamingo/feature/product/data/model/product.dart';
import 'package:flamingo/feature/product/screen/product-listing/snippet_product_listing.dart';
import 'package:flamingo/feature/product/data/model/product_filter_params.dart';
import 'package:flamingo/feature/product/screen/product-listing/multi_select_filter_sheet.dart';
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
    final vm = Provider.of<SearchViewModel>(context, listen: false);
    // Start each search unfiltered, then load the brand options for the keyword.
    vm.applyFilters(widget.keyword, const ProductFilterParams());
    vm.getSearchBrands(widget.keyword);
    super.initState();
  }

  Widget _buildFilterRow(SearchViewModel vm) {
    final f = vm.filters;
    final hasPrice = f.minPrice != null || f.maxPrice != null;
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: Dimens.spacingSizeSmall),
        children: [
          _filterPill(
            label: f.sellerIds.isNotEmpty
                ? 'Brand (${f.sellerIds.length})'
                : 'Brand',
            icon: Icons.expand_more,
            selected: f.sellerIds.isNotEmpty,
            onTap: () => _openBrandPicker(vm),
          ),
          _filterPill(
            label: hasPrice ? 'Price ✓' : 'Price',
            icon: Icons.expand_more,
            selected: hasPrice,
            onTap: () => _openPricePicker(vm),
          ),
          _filterPill(
            label: 'Sale',
            icon: Icons.local_offer_outlined,
            selected: f.onSale,
            onTap: () => vm.applyFilters(
              widget.keyword,
              f.copyWith(onSale: !f.onSale),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterPill({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: Dimens.spacingSizeSmall),
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: selected ? AppColors.white : AppColors.grayDarker,
          backgroundColor: selected ? AppColors.grayDarker : Colors.transparent,
          side: BorderSide(
              color: selected ? AppColors.grayDarker : AppColors.grayLight),
          visualDensity: VisualDensity.compact,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimens.radiusSmall)),
        ),
      ),
    );
  }

  Future<void> _openBrandPicker(SearchViewModel vm) async {
    final brands = vm.searchBrandsUseCase.data ?? [];
    final result = await showMultiSelectFilterSheet(
      context: context,
      title: 'Choose brand',
      options: [
        for (final b in brands)
          MultiSelectOption(value: b.sellerId, label: b.storeName)
      ],
      initialSelected: vm.filters.sellerIds.toSet(),
    );
    if (result != null) {
      await vm.applyFilters(
        widget.keyword,
        vm.filters.copyWith(sellerIds: result.toList()),
      );
    }
  }

  Future<void> _openPricePicker(SearchViewModel vm) async {
    final f = vm.filters;
    final minCtrl = TextEditingController(
        text: f.minPrice != null ? (f.minPrice! ~/ 100).toString() : '');
    final maxCtrl = TextEditingController(
        text: f.maxPrice != null ? (f.maxPrice! ~/ 100).toString() : '');
    final apply = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Price range (Rs)'),
        content: Row(
          children: [
            Expanded(
              child: TextField(
                controller: minCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Min'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: maxCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Max'),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Clear')),
          ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Apply')),
        ],
      ),
    );
    if (apply == null) return; // dismissed
    final minRs = int.tryParse(minCtrl.text.trim());
    final maxRs = int.tryParse(maxCtrl.text.trim());
    // Rupees in the UI, paisa on the wire.
    final newFilters = ProductFilterParams(
      categoryIds: f.categoryIds,
      sizeValues: f.sizeValues,
      sellerIds: f.sellerIds,
      onSale: f.onSale,
      minPrice: apply && minRs != null ? minRs * 100 : null,
      maxPrice: apply && maxRs != null ? maxRs * 100 : null,
    );
    await vm.applyFilters(widget.keyword, newFilters);
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
              const VerticalSpaceWidget(height: Dimens.spacingSizeSmall),
              _buildFilterRow(viewModel),
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
