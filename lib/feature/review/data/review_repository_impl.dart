import 'package:flamingo/data/data.dart';
import 'package:flamingo/data/model/paginated_option.dart';
import 'package:flamingo/feature/review/data/model/create_review_request.dart';
import 'package:flamingo/feature/review/data/model/review.dart';
import 'package:flamingo/feature/review/data/model/review_filter_params.dart';
import 'package:flamingo/feature/review/data/model/review_summary.dart';
import 'package:flamingo/feature/review/data/remote/review_remote.dart';
import 'package:flamingo/feature/review/data/review_repository.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemote _reviewRemote;

  ReviewRepositoryImpl({required ReviewRemote reviewRemote})
      : _reviewRemote = reviewRemote;

  @override
  Future<ReviewSummary> getReviewSummary(String productId) async {
    return await _reviewRemote.getReviewSummary(productId);
  }

  @override
  Future<FetchResponse<Review>> getProductReviews(
    String productId, {
    ReviewFilterParams? filters,
    PaginationOption? paginationOption,
  }) async {
    return await _reviewRemote.getProductReviews(
      productId,
      filters: filters,
      paginationOption: paginationOption,
    );
  }

  @override
  Future<Review?> getMyReviewForProduct(String productId) async {
    return await _reviewRemote.getMyReviewForProduct(productId);
  }

  @override
  Future<Review> createReview(CreateReviewRequest request) async {
    return await _reviewRemote.createReview(request);
  }

  @override
  Future<Review> updateReview(
      String reviewId, CreateReviewRequest request) async {
    return await _reviewRemote.updateReview(reviewId, request);
  }

  @override
  Future<void> deleteReview(String reviewId) async {
    return await _reviewRemote.deleteReview(reviewId);
  }
}
