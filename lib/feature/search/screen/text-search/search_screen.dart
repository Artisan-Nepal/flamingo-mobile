import 'dart:async';

import 'package:flamingo/feature/search/screen/text-search/brand_search_result_screen.dart';
import 'package:flamingo/feature/search/screen/text-search/search_result_screen.dart';
import 'package:flamingo/feature/search/screen/text-search/search_view_model.dart';
import 'package:flamingo/feature/vendor/screen/vendor-profile/vendor_profile_screen.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/button/variants/text_button_widget.dart';
import 'package:flamingo/widget/error/default_error_widget.dart';
import 'package:flamingo/widget/loader/loader.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    this.initialText,
    this.isInitial = false,
    this.initialScope = SearchScope.product,
  });

  final String? initialText;
  final bool isInitial;
  final SearchScope initialScope;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    final viewModel = Provider.of<SearchViewModel>(context, listen: false);
    viewModel.setScope(widget.initialScope);
    if (widget.isInitial) {
      viewModel.init();
      viewModel.getSearchHistory();
    }
    _searchController.text = widget.initialText ?? "";
    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(SearchViewModel viewModel, String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (viewModel.scope == SearchScope.product) {
        viewModel.getSuggestions(text);
      } else {
        viewModel.getVendorSuggestions(text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SearchViewModel>(context, listen: false);
    return DefaultScreen(
      scrollable: false,
      automaticallyImplyAppBarLeading: false,
      appBarTitle: Consumer<SearchViewModel>(
        // Rebuilds on scope change so the hint follows the selected tab -
        // it previously always read "Search for products", even on Brands.
        builder: (context, watchedViewModel, child) => SearchBarFieldWidget(
          hintText: watchedViewModel.scope == SearchScope.brand
              ? 'Search for brands'
              : 'Search for products',
          controller: _searchController,
          autofocus: true,
          onChanged: (text) => _onChanged(viewModel, text),
          onSubmitted: (text) => _navigateToResultScreen(viewModel, text),
        ),
      ),
      appBarActions: [
        // Matches the right-edge padding convention used by the home app
        // bar's own action (CartButtonWidget) - without it, zeroing the
        // button's own padding left "Cancel" flush against the screen edge.
        Padding(
          padding: const EdgeInsets.only(right: Dimens.spacingSizeSmall),
          child: TextButtonWidget(
            label: 'Cancel',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            padding: EdgeInsets.zero,
            onPressed: () {
              NavigationHelper.pop(context);
            },
          ),
        )
      ],
      padding: EdgeInsets.zero,
      child: Consumer<SearchViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar sits in the app bar, which has no bottom margin of
              // its own - without this the toggle butted straight up against
              // it.
              const VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
              _buildScopeToggle(viewModel),
              const VerticalSpaceWidget(height: Dimens.spacingSizeLarge),
              Expanded(child: _buildBody(viewModel)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildScopeToggle(SearchViewModel viewModel) {
    final isBrand = viewModel.scope == SearchScope.brand;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimens.spacingSizeDefault,
      ),
      child: Container(
        height: 36,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: AppColors.grayLighter,
          borderRadius: BorderRadius.circular(Dimens.radiusSmall),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeInOut,
              alignment:
                  isBrand ? Alignment.centerRight : Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                heightFactor: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(Dimens.radius_5),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.08),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                _buildScopeTab(viewModel, SearchScope.product, 'Products'),
                _buildScopeTab(viewModel, SearchScope.brand, 'Brands'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScopeTab(
    SearchViewModel viewModel,
    SearchScope scope,
    String label,
  ) {
    final isSelected = viewModel.scope == scope;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (isSelected) return;
          viewModel.setScope(scope);
          final text = _searchController.text;
          if (text.isNotEmpty) {
            if (scope == SearchScope.product) {
              viewModel.getSuggestions(text);
            } else {
              viewModel.getVendorSuggestions(text);
            }
          }
        },
        child: Container(
          alignment: Alignment.center,
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeInOut,
            style: textTheme(context).bodyMedium!.copyWith(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? AppColors.grayDarker : AppColors.grayMain,
                ),
            child: Text(label),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(SearchViewModel viewModel) {
    if (viewModel.scope == SearchScope.brand) {
      return _buildBrandSuggestions(viewModel);
    }
    return _buildProductSuggestions(viewModel);
  }

  Widget _buildProductSuggestions(SearchViewModel viewModel) {
    if (viewModel.getSuggestionsUseCase.hasError) {
      return DefaultErrorWidget(
        errorMessage: viewModel.searchProductsUseCase.exception ?? "",
      );
    }
    if (viewModel.getSuggestionsUseCase.isLoading) {
      return const DefaultScreenLoaderWidget(
        manuallyCenter: true,
        manualTop: 0.1,
      );
    }
    if (!viewModel.getSuggestionsUseCase.hasCompleted) {
      return _buildIdleState(viewModel);
    }
    final suggestions = viewModel.getSuggestionsUseCase.data ?? [];
    // Brand scope already said "No brands found" here; product scope rendered
    // an empty list, so a query with no matches looked like a hung screen.
    if (suggestions.isEmpty) {
      return const DefaultErrorWidget(errorMessage: 'No suggestions found');
    }
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Dimens.spacingSizeDefault),
      child: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          return _buildListItem(
            title: suggestions[index],
            leading: const Icon(
              Icons.search,
              size: Dimens.iconSizeSmall,
              color: AppColors.grayMain,
            ),
            onTap: () {
              _searchController.text = suggestions[index];
              FocusScope.of(context).unfocus();
              _navigateToResultScreen(viewModel, suggestions[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildBrandSuggestions(SearchViewModel viewModel) {
    final useCase = viewModel.vendorSuggestionsUseCase;
    if (useCase.hasError) {
      return DefaultErrorWidget(errorMessage: useCase.exception ?? "");
    }
    if (useCase.isLoading) {
      return const DefaultScreenLoaderWidget(
        manuallyCenter: true,
        manualTop: 0.1,
      );
    }
    if (!useCase.hasCompleted) {
      return _buildIdleState(viewModel);
    }
    final vendors = useCase.data ?? [];
    if (vendors.isEmpty) {
      return const DefaultErrorWidget(errorMessage: 'No brands found');
    }
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Dimens.spacingSizeDefault),
      child: ListView.builder(
        itemCount: vendors.length,
        itemBuilder: (context, index) {
          final vendor = vendors[index];
          return _buildListItem(
            title: vendor.seller.storeName,
            leading: const Icon(Icons.storefront_outlined,
                size: Dimens.iconSizeSmall, color: AppColors.grayMain),
            onTap: () {
              FocusScope.of(context).unfocus();
              NavigationHelper.pop(context);
              NavigationHelper.push(
                context,
                VendorProfileScreen(seller: vendor.seller),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildIdleState(SearchViewModel viewModel) {
    final hasHistory = viewModel.searchTextHistory.isNotEmpty;
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Dimens.spacingSizeDefault),
      child: ListView(
        children: [
          if (hasHistory) ...[
            _buildSectionHeader(
              'RECENT',
              action: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: viewModel.clearSearchHistory,
                child: Text(
                  'Clear all',
                  style: textTheme(context)
                      .bodySmall!
                      .copyWith(color: AppColors.grayMain),
                ),
              ),
            ),
            ...List.generate(viewModel.searchTextHistory.length, (i) {
              final index = viewModel.searchTextHistory.length - 1 - i;
              return _buildListItem(
                title: viewModel.searchTextHistory[index],
                leading: const Icon(
                  Icons.history,
                  size: Dimens.iconSizeSmall,
                  color: AppColors.grayMain,
                ),
                onTap: () {
                  _searchController.text = viewModel.searchTextHistory[index];
                  FocusScope.of(context).unfocus();
                  _navigateToResultScreen(
                      viewModel, viewModel.searchTextHistory[index]);
                },
                trailing: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    viewModel.removeSearchedText(
                        viewModel.searchTextHistory[index]);
                  },
                  child: const Icon(
                    Icons.close,
                    size: Dimens.iconSize_15,
                    // Secondary/destructive affordance - gray keeps it from
                    // competing with the search term itself, matching how
                    // trailing icons read elsewhere in the app.
                    color: AppColors.grayMain,
                  ),
                ),
              );
            }),
            const VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
          ],
          if (viewModel.scope == SearchScope.product) ...[
            // Not analytics-backed - these are a fixed, curated set (see
            // trendingSearchTerms), so the label says "popular", which is a
            // claim a hardcoded list can actually support.
            _buildSectionHeader('POPULAR SEARCHES'),
            Wrap(
              spacing: Dimens.spacingSizeSmall,
              runSpacing: Dimens.spacingSizeSmall,
              children: trendingSearchTerms.map((term) {
                return GestureDetector(
                  onTap: () {
                    _searchController.text = term;
                    FocusScope.of(context).unfocus();
                    _navigateToResultScreen(viewModel, term);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimens.spacingSizeDefault,
                      vertical: Dimens.spacingSizeSmall,
                    ),
                    decoration: BoxDecoration(
                      // Muted fill + soft line, the same treatment as the
                      // measurements banner and the "Brands you follow" card
                      // on home - a bare outline read heavier than everything
                      // around it.
                      color: AppColors.grayLighter,
                      border: Border.all(color: AppColors.grayLine),
                      borderRadius: BorderRadius.circular(Dimens.radiusLarge),
                    ),
                    child: Text(
                      term,
                      style: textTheme(context).bodyMedium,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  // Matches the home screen's section headers (SnippetHomeScreenTitle):
  // all-caps, bodyLarge, w500 - so search reads as the same app rather than
  // its own sentence-case island.
  Widget _buildSectionHeader(String title, {Widget? action}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimens.spacingSizeSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: textTheme(context).bodyLarge!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          if (action != null) action,
        ],
      ),
    );
  }

  _navigateToResultScreen(SearchViewModel viewModel, String? text) {
    if (text != null && text.isNotEmpty) {
      if (!widget.isInitial) NavigationHelper.pop(context);
      NavigationHelper.pop(context);
      final scope = viewModel.scope;
      NavigationHelper.pushWithoutAnimation(
        context,
        ChangeNotifierProvider.value(
          value: viewModel,
          child: scope == SearchScope.brand
              ? BrandSearchResultScreen(keyword: text)
              : SearchResultScreen(keyword: text),
        ),
      );
    }
  }

  Widget _buildListItem({
    required String title,
    Widget? leading,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        color: AppColors.transparent,
        height: 46,
        child: Row(
          children: [
            if (leading != null) ...[
              leading,
              const HorizontalSpaceWidget(width: Dimens.spacingSizeDefault),
            ],
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme(context).bodyMedium,
              ),
            ),
            if (trailing != null) ...[
              const HorizontalSpaceWidget(width: Dimens.spacingSizeDefault),
              trailing
            ]
          ],
        ),
      ),
    );
  }
}
