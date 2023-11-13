import 'package:flamingo/di/registration/feature/category.dart';
import 'package:flamingo/di/registration/feature/product.dart';
import 'package:flamingo/feature/category/data/category_repository.dart';
import 'package:flamingo/feature/dashboard/screen/cart/cartscreenmodel.dart';
import 'package:flamingo/feature/dashboard/screen/home/brand/brand_screen_model.dart';
import 'package:flamingo/feature/dashboard/screen/home/brand/brandprofilescreenmodel.dart';

import 'package:flamingo/feature/dashboard/screen/home/home/home_screen_model.dart';
import 'package:flamingo/feature/dashboard/screen/home/product/category/category_list_screenmodel.dart';
import 'package:flamingo/feature/dashboard/screen/home/product/product/productscreen_model.dart';
import 'package:flamingo/feature/dashboard/screen/home/wishlist/wishlistscreenmodel.dart';
import 'package:flamingo/feature/dashboard/screen/profile_screen/edit_profile/edit_Profile_model.dart';
import 'package:flamingo/feature/dashboard/screen/profile_screen/me_screen_model.dart';
import 'package:flamingo/feature/product/data/product_repository.dart';

import 'package:flamingo/feature/profile/local/profile_local.dart';
import 'package:flamingo/feature/profile/local/profile_local_impl.dart';

import 'package:flamingo/feature/profile/profile_repository.dart';
import 'package:flamingo/feature/profile/profile_repository_impl.dart';

import 'package:flamingo/feature/profile/remote/profile_remote.dart';
import 'package:flamingo/feature/profile/remote/profile_remote_impl.dart';

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

  locator.registerLazySingleton<ProfileLocal>(
    () => ProfileLocalImpl(
      sharedPrefManager: locator<LocalStorageClient>(
        instanceName: ServiceNames.sharedPrefManager,
      ),
    ),
  );

  locator.registerLazySingleton<ProfileRemote>(
    () => ProfileRemoteImpl(
      apiClient: locator<ApiClient>(),
    ),
  );
  locator.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      profileLocal: locator<ProfileLocal>(),
      profileRemote: locator<ProfileRemote>(),
    ),
  );

  locator.registerFactory<LoginViewModel>(
    () => LoginViewModel(
      authRepository: locator<AuthRepository>(),
    ),
  );

  locator.registerFactory<MeScreenModel>(
    () => MeScreenModel(
      profileRepository: locator<ProfileRepository>(),
    ),
  );

  locator.registerFactory<EditProfileModel>(
    () => EditProfileModel(
      profileRepository: locator<ProfileRepository>(),
    ),
  );
  locator.registerFactory<BrandScreenModel>(
    () => BrandScreenModel(
      profileRepository: locator<ProfileRepository>(),
    ),
  );

  locator
      .registerLazySingleton<HomescreenviewModel>(() => HomescreenviewModel());

  locator.registerFactory<ProductScreenModel>(
    () => ProductScreenModel(
      productRepository: locator<ProductRepository>(),
    ),
  );
  registerCategoryFeature(locator);
  registerProductFeature(locator);

  locator.registerFactory<BrandProfileScreenmodel>(
    () => BrandProfileScreenmodel(
      profileRepository: locator<ProfileRepository>(),
      productRepository: locator<ProductRepository>(),
    ),
  );
  //for wishlist
  locator.registerFactory<WishlistScreenModel>(
    () => WishlistScreenModel(
      profileRepository: locator<ProfileRepository>(),
      productRepository: locator<ProductRepository>(),
    ),
  );

  //for cart
  locator.registerFactory<CartScreenmodel>(
    () => CartScreenmodel(
      profileRepository: locator<ProfileRepository>(),
      productRepository: locator<ProductRepository>(),
    ),
  );

  locator.registerFactory<CategoryListScreenModel>(
    () => CategoryListScreenModel(
      categoryRepository: locator<CategoryRepository>(),
    ),
  );

  locator.registerFactory<OnboardingViewModel>(
    () => OnboardingViewModel(
      authRepository: locator<AuthRepository>(),
    ),
  );
}
