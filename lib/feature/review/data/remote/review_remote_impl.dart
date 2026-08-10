import 'package:flamingo/data/data.dart';
import 'package:flamingo/data/model/paginated_option.dart';
import 'package:flamingo/feature/review/data/model/create_review_request.dart';
import 'package:flamingo/feature/review/data/model/review.dart';
import 'package:flamingo/feature/review/data/model/review_filter_params.dart';
import 'package:flamingo/feature/review/data/model/review_summary.dart';
import 'package:flamingo/feature/review/data/remote/review_remote.dart';

class ReviewRemoteImpl implements ReviewRemote {
  final ApiClient _apiClient;

  ReviewRemoteImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<ReviewSummary> getReviewSummary(String productId) async {
    final url = ApiUrls.productReviewSummary.replaceFirst(':id', productId);
    final apiResponse = await _apiClient.get(url);
    return apiResponse.data == null
        ? ReviewSummary.empty()
        : ReviewSummary.fromJson(apiResponse.data);
  }

  @override
  Future<FetchResponse<Review>> getProductReviews(
    String productId, {
    ReviewFilterParams? filters,
    PaginationOption? paginationOption,
  }) async {
    final url = ApiUrls.productReviews.replaceFirst(':id', productId);
    final apiResponse = await _apiClient.get(
      url,
      queryParams: {
        ...?paginationOption?.toJson(),
        ...?filters?.toQueryParams(),
      },
    );
    return FetchResponse.fromJson(apiResponse.data, Review.fromJsonList);
  }

  @override
  Future<Review?> getMyReviewForProduct(String productId) async {
    final url = ApiUrls.myProductReview.replaceFirst(':id', productId);
    final apiResponse = await _apiClient.get(url);
    return apiResponse.data == null ? null : Review.fromJson(apiResponse.data);
  }

  @override
  Future<Review> createReview(CreateReviewRequest request) async {
    final apiResponse = await _apiClient.post(
      ApiUrls.reviews,
      body: request.toJson(),
    );
    return Review.fromJson(apiResponse.data);
  }

  @override
  Future<Review> updateReview(
      String reviewId, CreateReviewRequest request) async {
    final url = ApiUrls.reviewById.replaceFirst(':id', reviewId);
    final apiResponse = await _apiClient.patch(url, body: request.toJson());
    return Review.fromJson(apiResponse.data);
  }

  @override
  Future<void> deleteReview(String reviewId) async {
    final url = ApiUrls.reviewById.replaceFirst(':id', reviewId);
    await _apiClient.delete(url);
  }
}
