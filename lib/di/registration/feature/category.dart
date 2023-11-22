import 'package:flamingo/data/data.dart';
import 'package:flamingo/di/service_names.dart';
import 'package:flamingo/feature/category/data/category_repository.dart';
import 'package:flamingo/feature/category/data/category_repository_impl.dart';
import 'package:flamingo/feature/category/data/local/category_local.dart';
import 'package:flamingo/feature/category/data/local/category_local_impl.dart';
import 'package:flamingo/feature/category/data/remote/category_remote.dart';
import 'package:flamingo/feature/category/data/remote/category_remote_impl.dart';
import 'package:flamingo/feature/category/screen/category-search/category_search_view_model.dart';
import 'package:get_it/get_it.dart';

void registerCategoryFeature(GetIt locator) {
  locator.registerLazySingleton<CategoryLocal>(
    () => CategoryLocalImpl(
      sharedPrefManager: locator<LocalStorageClient>(
        instanceName: ServiceNames.sharedPrefManager,
      ),
    ),
  );
  locator.registerLazySingleton<CategoryRemote>(
    () => CategoryRemoteImpl(
      apiClient: locator<ApiClient>(),
    ),
  );
  locator.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(
      categoryLocal: locator<CategoryLocal>(),
      categoryRemote: locator<CategoryRemote>(),
    ),
  );
  locator.registerFactory<CategorySearchViewModel>(
    () => CategorySearchViewModel(
      categoryRepository: locator<CategoryRepository>(),
    ),
  );
}
