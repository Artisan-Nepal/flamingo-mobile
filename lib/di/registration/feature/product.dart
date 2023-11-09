import 'package:flamingo/data/data.dart';
import 'package:flamingo/di/service_names.dart';
import 'package:flamingo/feature/category/data/category_repository.dart';
import 'package:flamingo/feature/category/data/model/model.dart';
import 'package:flamingo/feature/dashboard/screen/home/main/main_home_screen_model.dart';
import 'package:flamingo/feature/dashboard/screen/home/search/searchscreen_model.dart';
import 'package:flamingo/feature/product/data/local/product_local.dart';
import 'package:flamingo/feature/product/data/local/product_local_impl.dart';
import 'package:flamingo/feature/product/data/product_repository.dart';
import 'package:flamingo/feature/product/data/product_repository_impl.dart';
import 'package:flamingo/feature/product/data/remote/product_remote.dart';
import 'package:flamingo/feature/product/data/remote/product_remote_impl.dart';

import 'package:get_it/get_it.dart';

void registerProductFeature(GetIt locator) {
  locator.registerLazySingleton<ProductLocal>(
    () => ProductLocalImpl(
      sharedPrefManager: locator<LocalStorageClient>(
        instanceName: ServiceNames.sharedPrefManager,
      ),
    ),
  );
  locator.registerLazySingleton<ProductRemote>(
    () => ProductRemoteImpl(
      apiClient: locator<ApiClient>(),
    ),
  );
  locator.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      productLocal: locator<ProductLocal>(),
      productRemote: locator<ProductRemote>(),
    ),
  );
  locator.registerFactory<MainHometScreenModel>(
    () => MainHometScreenModel(
      productRepository: locator<ProductRepository>(),
    ),
  );

  locator.registerFactory<SearchScreenModel>(
    () => SearchScreenModel(
      categoryRepository: locator<CategoryRepository>(),
    ),
  );
}
