import 'package:flamingo/data/model/paginated_option.dart';
import 'package:flamingo/di/di.dart';
import 'package:flamingo/feature/review/data/model/review_filter_params.dart';
import 'package:flamingo/feature/review/screen/product-reviews/product_review_view_model.dart';
import 'package:flamingo/feature/review/screen/product-reviews/snippet_review_sort_sheet.dart';
import 'package:flamingo/feature/review/screen/product-reviews/snippet_review_summary.dart';
import 'package:flamingo/feature/review/screen/product-reviews/snippet_review_tile.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/widget/error/default_error_widget.dart';
import 'package:flamingo/widget/load-more/load_more_view_model.dart';
import 'package:flamingo/widget/loader/default_screen_loader_widget.dart';
import 'package:flamingo/widget/refresher/refresher_widget.dart';
import 'package:flamingo/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ReviewListScreen extends StatefulWidget {
  const ReviewListScreen({
    super.key,
    required this.productId,
    required this.productTitle,
  });

  final String productId;
  final String productTitle;

  @override
  State<ReviewListScreen> createState() => _ReviewListScreenState();
}

class _ReviewListScreenState extends State<ReviewListScreen> {
  final _viewModel = locator<ProductReviewViewModel>();
  final _loadMoreViewModel = locator<LoadMoreViewModel>();
  final _refreshController = RefreshController(initialRefresh: false);

  static const _starFilters = [null, 5, 4, 3, 2, 1];

  @override
  void initState() {
    super.initState();
    _viewModel.loadSummary(widget.productId);
    _viewModel.loadReviews(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _loadMoreViewModel,
      child: ChangeNotifierProvider(
        create: (context) => _viewModel,
        child: Consumer<ProductReviewViewModel>(
          builder: (context, viewModel, child) {
            final total = viewModel.summaryUseCase.data?.totalCount ??
                viewModel.reviewsUseCase.data?.metadata.total ??
                0;
            return TitledScreen(
              title: 'Reviews ($total)',
              scrollable: false,
              padding: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.spacingSizeDefault),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (viewModel.summaryUseCase.hasCompleted &&
                        viewModel.summaryUseCase.data!.totalCount > 0) ...[
                      SnippetReviewSummary(
                          summary: viewModel.summaryUseCase.data!),
                      const SizedBox(height: Dimens.spacingSizeDefault),
                      _buildControlsRow(context, viewModel),
                      const SizedBox(height: Dimens.spacingSizeSmall),
                      Divider(color: AppColors.grayLight),
                    ],
                    Expanded(child: _buildList(viewModel)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildControlsRow(
      BuildContext context, ProductReviewViewModel viewModel) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => _openSortSheet(viewModel),
          child: Row(
            children: [
              const Icon(Icons.sort, size: Dimens.iconSizeSmall),
              const SizedBox(width: 4),
              TextWidget(
                viewModel.filters.sort.label,
                style: textTheme(context).bodyMedium!,
              ),
            ],
          ),
        ),
        const SizedBox(width: Dimens.spacingSizeDefault),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _starFilters.map((star) {
                final isSelected = viewModel.filters.star == star;
                return Padding(
                  padding:
                      const EdgeInsets.only(right: Dimens.spacingSizeExtraSmall),
                  child: ChoiceChip(
                    label: Text(star == null ? 'All' : '$star ★'),
                    selected: isSelected,
                    onSelected: (_) => _applyFilters(
                      viewModel,
                      viewModel.filters.copyWith(
                        star: star,
                        clearStar: star == null,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openSortSheet(ProductReviewViewModel viewModel) async {
    final result = await showModalBottomSheet<ReviewSort>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) =>
          SnippetReviewSortSheet(selected: viewModel.filters.sort),
    );
    if (result != null) {
      _applyFilters(viewModel, viewModel.filters.copyWith(sort: result));
    }
  }

  // applyFilters() re-fetches page 1 under the new filter, but the shared
  // LoadMoreViewModel's page counter (seeded once by RefresherWidget) doesn't
  // know that - without this reset, scrolling to load more after switching
  // filters would resume from whatever page the *previous* filter had reached,
  // silently skipping results under the new one.
  void _applyFilters(ProductReviewViewModel viewModel, ReviewFilterParams filters) {
    _loadMoreViewModel.init(2, 10);
    viewModel.applyFilters(widget.productId, filters);
  }

  Widget _buildList(ProductReviewViewModel viewModel) {
    final useCase = viewModel.reviewsUseCase;
    if (useCase.isLoading) return const DefaultScreenLoaderWidget();
    if (useCase.hasError) {
      return DefaultErrorWidget(
        errorMessage: useCase.exception!,
        onActionButtonPressed: () => _viewModel.loadReviews(widget.productId),
      );
    }

    final reviews = useCase.data?.rows ?? [];
    if (reviews.isEmpty) {
      return const DefaultErrorWidget(
        needImage: false,
        errorMessage: 'No reviews match this filter.',
      );
    }

    return RefresherWidget(
      controller: _refreshController,
      enablePullUp: reviews.length >= 10,
      onRefresh: () async {
        await _viewModel.loadReviews(widget.productId, updateState: false);
      },
      onLoadMore: (int page, int limit) async {
        await viewModel.loadReviews(
          widget.productId,
          updateState: false,
          paginate: true,
          paginationOption: PaginationOption(page: page, limit: limit),
        );
        return incrementPage(viewModel.reviewsUseCase);
      },
      child: ListView.separated(
        padding: const EdgeInsets.only(
          top: Dimens.spacingSizeDefault,
          bottom: Dimens.spacingSizeExtraLarge,
        ),
        itemCount: reviews.length,
        separatorBuilder: (context, index) => Padding(
          padding:
              const EdgeInsets.symmetric(vertical: Dimens.spacingSizeDefault),
          child: Divider(color: AppColors.grayLight),
        ),
        itemBuilder: (context, index) =>
            SnippetReviewTile(review: reviews[index]),
      ),
    );
  }
}
