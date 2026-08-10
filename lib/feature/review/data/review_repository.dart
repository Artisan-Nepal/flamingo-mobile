import 'package:flamingo/data/data.dart';
import 'package:flamingo/data/model/paginated_option.dart';
import 'package:flamingo/feature/review/data/model/create_review_request.dart';
import 'package:flamingo/feature/review/data/model/review.dart';
import 'package:flamingo/feature/review/data/model/review_filter_params.dart';
import 'package:flamingo/feature/review/data/model/review_summary.dart';

abstract class ReviewRepository {
  Future<ReviewSummary> getReviewSummary(String productId);
  Future<FetchResponse<Review>> getProductReviews(
    String productId, {
    ReviewFilterParams? filters,
    PaginationOption? paginationOption,
  });
  Future<Review?> getMyReviewForProduct(String productId);
  Future<Review> createReview(CreateReviewRequest request);
  Future<Review> updateReview(String reviewId, CreateReviewRequest request);
  Future<void> deleteReview(String reviewId);
}
