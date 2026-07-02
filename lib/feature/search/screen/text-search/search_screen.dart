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
      appBarTitle: Container(
        child: SearchBarFieldWidget(
          hintText: 'Search for products',
          controller: _searchController,
          autofocus: true,
          onChanged: (text) => _onChanged(viewModel, text),
          onSubmitted: (text) => _navigateToResultScreen(viewModel, text),
        ),
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
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildScopeToggle(viewModel),
              const VerticalSpaceWidget(height: Dimens.spacingSizeSmall),
              Expanded(child: _buildBody(viewModel)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildScopeToggle(SearchViewModel viewModel) {
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
        child: Row(
          children: [
            _buildScopeTab(viewModel, SearchScope.product, 'Products'),
            _buildScopeTab(viewModel, SearchScope.brand, 'Brands'),
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.white : AppColors.transparent,
            borderRadius: BorderRadius.circular(Dimens.radius_5),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppColors.grayDarker : AppColors.grayMain,
            ),
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
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Dimens.spacingSizeDefault),
      child: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          return _buildListItem(
            title: suggestions[index],
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
            Text(
              'Recent',
              style: textTheme(context)
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const VerticalSpaceWidget(height: Dimens.spacingSizeExtraSmall),
            ...List.generate(viewModel.searchTextHistory.length, (i) {
              final index = viewModel.searchTextHistory.length - 1 - i;
              return _buildListItem(
                title: viewModel.searchTextHistory[index],
                onTap: () {
                  _searchController.text = viewModel.searchTextHistory[index];
                  FocusScope.of(context).unfocus();
                  _navigateToResultScreen(
                      viewModel, viewModel.searchTextHistory[index]);
                },
                trailing: GestureDetector(
                  onTap: () {
                    viewModel.removeSearchedText(
                        viewModel.searchTextHistory[index]);
                  },
                  child: const Icon(
                    Icons.close,
                    size: Dimens.iconSize_15,
                    color: AppColors.primaryMain,
                  ),
                ),
              );
            }),
            const VerticalSpaceWidget(height: Dimens.spacingSizeSmall),
          ],
          if (viewModel.scope == SearchScope.product) ...[
            Text(
              'Trending',
              style: textTheme(context)
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const VerticalSpaceWidget(height: Dimens.spacingSizeSmall),
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
                      vertical: Dimens.spacingSizeExtraSmall,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.grayLight),
                      borderRadius: BorderRadius.circular(Dimens.radiusLarge),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.trending_up,
                            size: Dimens.iconSizeExtraSmall,
                            color: AppColors.grayMain),
                        const HorizontalSpaceWidget(
                            width: Dimens.spacing_2),
                        Text(term),
                      ],
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
      onTap: onTap,
      child: Container(
        color: AppColors.transparent,
        height: 40,
        child: Row(
          children: [
            if (leading != null) ...[
              leading,
              const HorizontalSpaceWidget(width: Dimens.spacingSizeSmall),
            ],
            Expanded(child: Text(title)),
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
