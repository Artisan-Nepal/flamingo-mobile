import 'package:flamingo/feature/search/screen/text-search/search_screen.dart';
import 'package:flamingo/feature/search/screen/text-search/search_view_model.dart';
import 'package:flamingo/feature/vendor/screen/vendor-listing/vendor_listing_screen.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/error/default_error_widget.dart';
import 'package:flamingo/widget/loader/loader.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BrandSearchResultScreen extends StatefulWidget {
  const BrandSearchResultScreen({
    super.key,
    required this.keyword,
  });

  final String keyword;

  @override
  State<BrandSearchResultScreen> createState() =>
      _BrandSearchResultScreenState();
}

class _BrandSearchResultScreenState extends State<BrandSearchResultScreen> {
  final _searchController = SearchController();

  @override
  void initState() {
    _searchController.text = widget.keyword;
    Provider.of<SearchViewModel>(context, listen: false)
        .searchVendors(widget.keyword);
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
          hintText: 'Search for brands',
          onTap: () {
            NavigationHelper.pushWithoutAnimation(
              context,
              SearchScreen(
                initialText: widget.keyword,
                initialScope: SearchScope.brand,
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
          final useCase = viewModel.searchVendorsUseCase;
          if (useCase.isLoading) {
            return const DefaultScreenLoaderWidget(
              manuallyCenter: true,
              manualTop: 0.1,
            );
          }
          if (useCase.hasError) {
            return DefaultErrorWidget(
              manuallyCenter: true,
              manualTop: 0.1,
              errorMessage: useCase.exception ?? '',
            );
          }
          final vendors = useCase.data ?? [];
          if (!useCase.hasCompleted || vendors.isEmpty) {
            return DefaultErrorWidget(
              manuallyCenter: true,
              manualTop: 0.1,
              errorMessage: 'Sorry, no brands found',
            );
          }
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  vertical: Dimens.spacingSizeSmall,
                  horizontal: Dimens.spacingSizeSmall,
                ),
                sliver: SnippetVendorListing(vendors: vendors),
              ),
            ],
          );
        },
      ),
    );
  }
}
