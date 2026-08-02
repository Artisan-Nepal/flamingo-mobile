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
    // Slider bound from the loaded results, but never below any already-applied
    // max so the current selection always fits on the track.
    var bound = priceUpperBoundRupees(vm.searchProductsUseCase.data ?? []);
    if (f.maxPrice != null && f.maxPrice! / 100 > bound) {
      bound = (f.maxPrice! / 100).ceilToDouble();
    }

    final result = await showModalBottomSheet<_PriceResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => _PriceRangeSheet(
        maxBound: bound,
        initialMin: f.minPrice != null ? f.minPrice! ~/ 100 : null,
        initialMax: f.maxPrice != null ? f.maxPrice! ~/ 100 : null,
      ),
    );
    if (result == null) return; // dismissed

    // Rupees in the UI, paisa on the wire. A full-span range means "no price
    // filter" - clear it so the pill doesn't falsely read as active.
    final isFullRange =
        result.cleared || (result.min <= 0 && result.max >= bound.round());
    final newFilters = ProductFilterParams(
      categoryIds: f.categoryIds,
      sizeValues: f.sizeValues,
      sellerIds: f.sellerIds,
      onSale: f.onSale,
      minPrice: isFullRange || result.min <= 0 ? null : result.min * 100,
      maxPrice: isFullRange ? null : result.max * 100,
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

/// Outcome of the price bottom sheet: the chosen range (rupees), or a flag that
/// the user tapped Clear.
class _PriceResult {
  final int min;
  final int max;
  final bool cleared;
  const _PriceResult({this.min = 0, this.max = 0, this.cleared = false});
}

/// Bottom sheet wrapping [PriceRangeSelector] with Clear / Apply actions, used by
/// the search price filter.
class _PriceRangeSheet extends StatefulWidget {
  const _PriceRangeSheet({
    required this.maxBound,
    this.initialMin,
    this.initialMax,
  });

  final double maxBound;
  final int? initialMin;
  final int? initialMax;

  @override
  State<_PriceRangeSheet> createState() => _PriceRangeSheetState();
}

class _PriceRangeSheetState extends State<_PriceRangeSheet> {
  late int _min = widget.initialMin ?? 0;
  late int _max = widget.initialMax ?? widget.maxBound.round();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(Dimens.spacingSizeDefault),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: Dimens.spacingSizeSmall),
                  decoration: BoxDecoration(
                    color: AppColors.grayLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Text(
                'Price range',
                style: TextStyle(
                  fontSize: Dimens.fontSizeLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
              PriceRangeSelector(
                maxBound: widget.maxBound,
                initialMin: _min,
                initialMax: _max,
                onChanged: (min, max) {
                  _min = min;
                  _max = max;
                },
              ),
              const VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(
                        context,
                        const _PriceResult(cleared: true),
                      ),
                      child: const Text('Clear'),
                    ),
                  ),
                  const HorizontalSpaceWidget(width: Dimens.spacingSizeSmall),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(
                        context,
                        _PriceResult(min: _min, max: _max),
                      ),
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
