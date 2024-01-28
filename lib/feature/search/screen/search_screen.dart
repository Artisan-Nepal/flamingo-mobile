import 'package:flamingo/feature/search/screen/search_result_screen.dart';
import 'package:flamingo/feature/search/screen/search_view_model.dart';
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
  });

  final String? initialText;
  final bool isInitial;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    if (widget.isInitial) {
      Provider.of<SearchViewModel>(context, listen: false).init();
      Provider.of<SearchViewModel>(context, listen: false).getSearchHistory();
    }
    _searchController.text = widget.initialText ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SearchViewModel>(context, listen: false);
    return DefaultScreen(
      scrollable: false,
      automaticallyImplyAppBarLeading: false,
      appBarTitle: Container(
        child: SearchBarFieldWidget(
          hintText: "Search for products",
          controller: _searchController,
          autofocus: true,
          onChanged: (text) {
            viewModel.getSuggestions(text);
          },
          onSubmitted: (text) {
            _navigateToResultScreen(viewModel, text);
          },
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
          if (viewModel.getSuggestionsUseCase.hasError) {
            return Expanded(
              child: DefaultErrorWidget(
                errorMessage: viewModel.searchProductsUseCase.exception ?? "",
              ),
            );
          }
          if (viewModel.getSuggestionsUseCase.isLoading) {
            return const DefaultScreenLoaderWidget(
              manuallyCenter: true,
              manualTop: 0.1,
            );
          }
          if (viewModel.searchTextHistory.isNotEmpty &&
              !viewModel.getSuggestionsUseCase.hasCompleted) {
            return _buildSearchHistory(viewModel);
          }
          final suggestions = viewModel.getSuggestionsUseCase.data ?? [];
          return Container(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimens.spacingSizeDefault,
              ),
              child: ListView.builder(
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  return _buildListItem(
                    title: suggestions[index],
                    onTap: () {
                      _searchController.text = suggestions[index];
                      FocusScope.of(context).unfocus();
                      _navigateToResultScreen(
                        viewModel,
                        suggestions[index],
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  _navigateToResultScreen(SearchViewModel viewModel, String? text) {
    if (text != null && text.isNotEmpty) {
      if (!widget.isInitial) NavigationHelper.pop(context);
      NavigationHelper.pop(context);
      NavigationHelper.pushWithoutAnimation(
        context,
        ChangeNotifierProvider.value(
          value: viewModel,
          child: SearchResultScreen(keyword: text),
        ),
      );
    }
  }

  _buildSearchHistory(SearchViewModel viewModel) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimens.spacingSizeDefault),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent',
            style: textTheme(context).bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          VerticalSpaceWidget(height: Dimens.spacingSizeDefault),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: viewModel.searchTextHistory.length,
              itemBuilder: (context, i) {
                int index = viewModel.searchTextHistory.length - 1 - i;
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
                    child: Icon(
                      Icons.close,
                      size: Dimens.iconSize_15,
                      color: AppColors.primaryMain,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(
      {required String title, Widget? trailing, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: AppColors.transparent,
        height: 40,
        child: Row(
          children: [
            Expanded(child: Text(title)),
            if (trailing != null) ...[
              HorizontalSpaceWidget(width: Dimens.spacingSizeDefault),
              trailing
            ]
          ],
        ),
      ),
    );
  }
}
