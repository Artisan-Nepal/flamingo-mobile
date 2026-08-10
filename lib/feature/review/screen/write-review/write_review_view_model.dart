import 'package:flamingo/feature/review/data/model/create_review_request.dart';
import 'package:flamingo/feature/review/data/model/review.dart';
import 'package:flamingo/feature/review/data/review_repository.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/cupertino.dart';

class WriteReviewViewModel extends ChangeNotifier {
  final ReviewRepository _reviewRepository;

  WriteReviewViewModel({required ReviewRepository reviewRepository})
      : _reviewRepository = reviewRepository;

  int _rating = 0;
  int get rating => _rating;

  void setRating(int value) {
    _rating = value;
    notifyListeners();
  }

  bool get canSubmit => _rating >= 1;

  // Set once prefillFor() resolves. Non-null means the form is editing an
  // existing review rather than creating one (drives PATCH vs POST and shows
  // the Delete action).
  Review? _existingReview;
  Review? get existingReview => _existingReview;
  bool get isEditing => _existingReview != null;

  Response<Review?> _myReviewUseCase = Response<Review?>();
  Response<Review?> get myReviewUseCase => _myReviewUseCase;

  void setMyReviewUseCase(Response<Review?> response) {
    _myReviewUseCase = response;
    if (response.hasCompleted) {
      _existingReview = response.data;
      if (_existingReview != null) _rating = _existingReview!.rating;
    }
    notifyListeners();
  }

  // Looks up whether this customer already reviewed the product, so the form
  // opens pre-filled (title/comment default text lives in the screen's
  // TextEditingControllers, seeded from existingReview once this resolves).
  Future<void> prefillFor(String productId) async {
    try {
      setMyReviewUseCase(Response.loading());
      final review = await _reviewRepository.getMyReviewForProduct(productId);
      setMyReviewUseCase(Response.complete(review));
    } catch (exception) {
      setMyReviewUseCase(Response.error(exception));
    }
  }

  Response<Review> _submitUseCase = Response<Review>();
  Response<Review> get submitUseCase => _submitUseCase;

  void setSubmitUseCase(Response<Review> response) {
    _submitUseCase = response;
    notifyListeners();
  }

  Future<void> submit({
    required String productId,
    String? title,
    String? comment,
  }) async {
    try {
      setSubmitUseCase(Response.loading());
      final request = CreateReviewRequest(
        productId: productId,
        rating: _rating,
        title: title,
        comment: comment,
      );
      final response = isEditing
          ? await _reviewRepository.updateReview(_existingReview!.id, request)
          : await _reviewRepository.createReview(request);
      setSubmitUseCase(Response.complete(response));
    } catch (exception) {
      setSubmitUseCase(Response.error(exception));
    }
  }

  Response<bool> _deleteUseCase = Response<bool>();
  Response<bool> get deleteUseCase => _deleteUseCase;

  void setDeleteUseCase(Response<bool> response) {
    _deleteUseCase = response;
    notifyListeners();
  }

  Future<void> delete() async {
    if (_existingReview == null) return;
    try {
      setDeleteUseCase(Response.loading());
      await _reviewRepository.deleteReview(_existingReview!.id);
      setDeleteUseCase(Response.complete(true));
    } catch (exception) {
      setDeleteUseCase(Response.error(exception));
    }
  }
}
