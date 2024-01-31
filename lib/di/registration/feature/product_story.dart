import 'package:flamingo/data/data.dart';
import 'package:flamingo/di/service_names.dart';
import 'package:flamingo/feature/feature.dart';
import 'package:flamingo/feature/product-story/data/local/product_story_local.dart';
import 'package:flamingo/feature/product-story/data/local/product_story_local_impl.dart';
import 'package:flamingo/feature/product-story/data/product_story_repository.dart';
import 'package:flamingo/feature/product-story/data/product_story_repository_impl.dart';
import 'package:flamingo/feature/product-story/data/remote/product_story_remote.dart';
import 'package:flamingo/feature/product-story/data/remote/product_story_remote_impl.dart';
import 'package:flamingo/feature/product-story/product_story_engagement_view_model.dart';
import 'package:flamingo/feature/product-story/product_story_view_model.dart';
import 'package:get_it/get_it.dart';

void registerProductStoryFeature(GetIt locator) {
  locator.registerLazySingleton<ProductStoryLocal>(
    () => ProductStoryLocalImpl(
      sharedPrefManager: locator<LocalStorageClient>(
        instanceName: ServiceNames.sharedPrefManager,
      ),
    ),
  );
  locator.registerLazySingleton<ProductStoryRemote>(
    () => ProductStoryRemoteImpl(
      apiClient: locator<ApiClient>(),
    ),
  );
  locator.registerLazySingleton<ProductStoryRepository>(
    () => ProductStoryRepositoryImpl(
      productStoryLocal: locator<ProductStoryLocal>(),
      productStoryRemote: locator<ProductStoryRemote>(),
      authRepository: locator<AuthRepository>(),
    ),
  );
  locator.registerFactory<ProductStoryViewModel>(
    () => ProductStoryViewModel(
      productStoryRepository: locator<ProductStoryRepository>(),
    ),
  );
  locator.registerLazySingleton<ProductStoryEngagementViewModel>(
    () => ProductStoryEngagementViewModel(),
  );
}
