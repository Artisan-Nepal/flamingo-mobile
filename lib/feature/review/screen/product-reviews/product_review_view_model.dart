import 'package:flamingo/data/data.dart';
import 'package:flamingo/data/model/paginated_option.dart';
import 'package:flamingo/feature/review/data/model/review.dart';
import 'package:flamingo/feature/review/data/model/review_filter_params.dart';
import 'package:flamingo/feature/review/data/model/review_summary.dart';
import 'package:flamingo/feature/review/data/review_repository.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/cupertino.dart';

class ProductReviewViewModel extends ChangeNotifier {
  final ReviewRepository _reviewRepository;

  ProductReviewViewModel({required ReviewRepository reviewRepository})
      : _reviewRepository = reviewRepository;

  Response<ReviewSummary> _summaryUseCase = Response<ReviewSummary>();
  Response<ReviewSummary> get summaryUseCase => _summaryUseCase;

  Response<FetchResponse<Review>> _reviewsUseCase =
      Response<FetchResponse<Review>>();
  Response<FetchResponse<Review>> get reviewsUseCase => _reviewsUseCase;

  ReviewFilterParams _filters = const ReviewFilterParams();
  ReviewFilterParams get filters => _filters;

  void setSummaryUseCase(Response<ReviewSummary> response) {
    _summaryUseCase = response;
    notifyListeners();
  }

  void setReviewsUseCase(Response<FetchResponse<Review>> response) {
    _reviewsUseCase = response;
    notifyListeners();
  }

  void appendReviewsUseCase(FetchResponse<Review> response) {
    _reviewsUseCase.data!.rows.addAll(response.rows);
    _reviewsUseCase.data!.metadata = response.metadata;
    notifyListeners();
  }

  Future<void> loadSummary(String productId) async {
    try {
      setSummaryUseCase(Response.loading());
      final response = await _reviewRepository.getReviewSummary(productId);
      setSummaryUseCase(Response.complete(response));
    } catch (exception) {
      setSummaryUseCase(Response.error(exception));
    }
  }

  Future<void> loadReviews(
    String productId, {
    bool updateState = true,
    bool paginate = false,
    PaginationOption? paginationOption,
  }) async {
    try {
      if (updateState) setReviewsUseCase(Response.loading());
      final response = await _reviewRepository.getProductReviews(
        productId,
        filters: _filters,
        paginationOption: paginationOption,
      );
      if (paginate) {
        appendReviewsUseCase(response);
      } else {
        setReviewsUseCase(Response.complete(response));
      }
    } catch (exception) {
      if (updateState) setReviewsUseCase(Response.error(exception));
    }
  }

  // Resets to page 1 under the new filters - called from the sort sheet /
  // star filter chips, both of which invalidate the current page list.
  Future<void> applyFilters(String productId, ReviewFilterParams filters) async {
    _filters = filters;
    await loadReviews(productId);
  }
}
