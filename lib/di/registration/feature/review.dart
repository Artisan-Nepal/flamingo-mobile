import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/review/data/remote/review_remote.dart';
import 'package:flamingo/feature/review/data/remote/review_remote_impl.dart';
import 'package:flamingo/feature/review/data/review_repository.dart';
import 'package:flamingo/feature/review/data/review_repository_impl.dart';
import 'package:flamingo/feature/review/screen/product-reviews/product_review_view_model.dart';
import 'package:flamingo/feature/review/screen/write-review/write_review_view_model.dart';
import 'package:get_it/get_it.dart';

void registerReviewFeature(GetIt locator) {
  locator.registerLazySingleton<ReviewRemote>(
    () => ReviewRemoteImpl(
      apiClient: locator<ApiClient>(),
    ),
  );
  locator.registerLazySingleton<ReviewRepository>(
    () => ReviewRepositoryImpl(
      reviewRemote: locator<ReviewRemote>(),
    ),
  );
  locator.registerFactory<ProductReviewViewModel>(
    () => ProductReviewViewModel(
      reviewRepository: locator<ReviewRepository>(),
    ),
  );
  locator.registerFactory<WriteReviewViewModel>(
    () => WriteReviewViewModel(
      reviewRepository: locator<ReviewRepository>(),
    ),
  );
}
