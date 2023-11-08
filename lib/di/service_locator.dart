import 'package:flamingo/di/registration/feature/category.dart';
import 'package:flamingo/di/registration/feature/product.dart';
import 'package:flamingo/feature/category/data/category_repository.dart';
import 'package:flamingo/feature/category/data/model/product_category.dart';
import 'package:flamingo/feature/dashboard/screen/home/home/home_screen_model.dart';
import 'package:flamingo/feature/dashboard/screen/home/product/product_list_screenmodel.dart';

import 'package:get_it/get_it.dart';
import 'package:flamingo/data/data.dart';
import 'package:flamingo/di/service_names.dart';
import 'package:flamingo/feature/feature.dart';
import 'package:flamingo/navigation/navigation_service.dart';

GetIt locator = GetIt.instance;

Future setUpServiceLocator() async {
  var sharedPref = await SharedPrefManager.getInstance();

  // Local Storage Clients
  locator.registerLazySingleton<LocalStorageClient>(
    () => SecureStorageManager(),
    instanceName: ServiceNames.secureStorageManager,
  );
  locator.registerLazySingleton<LocalStorageClient>(
    () => SharedPrefManager(
      sharedPref: sharedPref,
    ),
    instanceName: ServiceNames.sharedPrefManager,
  );

  // Remote Clients
  locator.registerLazySingleton<ApiClient>(
    () => DioApiClientImpl(
      sharedPrefManager: locator<LocalStorageClient>(
        instanceName: ServiceNames.sharedPrefManager,
      ),
    ),
  );

  // Navigation
  locator.registerLazySingleton(
    () => NavigationService(
      sharedPrefManager: locator<LocalStorageClient>(
        instanceName: ServiceNames.sharedPrefManager,
      ),
    ),
  );

  // Theme
  locator.registerLazySingleton<ThemeLocal>(
    () => ThemeLocalImpl(
      sharedPrefManager: locator<LocalStorageClient>(
        instanceName: ServiceNames.sharedPrefManager,
      ),
    ),
  );
  locator.registerLazySingleton<ThemeRepository>(
    () => ThemeRepositoryImpl(
      themeLocal: locator<ThemeLocal>(),
    ),
  );
  locator.registerLazySingleton<ThemeService>(
    () => ThemeService(
      themeRepository: locator<ThemeRepository>(),
    ),
  );

  // Auth
  locator.registerLazySingleton<AuthLocal>(
    () => AuthLocalImpl(
      sharedPrefManager: locator<LocalStorageClient>(
        instanceName: ServiceNames.sharedPrefManager,
      ),
    ),
  );
  locator.registerLazySingleton<AuthRemote>(
    () => AuthRemoteImpl(
      apiClient: locator<ApiClient>(),
    ),
  );
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authLocal: locator<AuthLocal>(),
      authRemote: locator<AuthRemote>(),
    ),
  );

  locator.registerFactory<LoginViewModel>(
    () => LoginViewModel(
      authRepository: locator<AuthRepository>(),
    ),
  );
  locator
      .registerLazySingleton<HomescreenviewModel>(() => HomescreenviewModel());
  registerCategoryFeature(locator);
  registerProductFeature(locator);

  locator.registerFactory<ProductListScreenModel>(
    () => ProductListScreenModel(
      categoryRepository: locator<CategoryRepository>(),
    ),
  );

  locator.registerFactory<OnboardingViewModel>(
    () => OnboardingViewModel(
      authRepository: locator<AuthRepository>(),
    ),
  );
}
