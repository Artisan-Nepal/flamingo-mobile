import 'package:flamingo/data/data.dart';
import 'package:flamingo/di/service_names.dart';
import 'package:flamingo/feature/cart/data/cart_repository.dart';
import 'package:flamingo/feature/feature.dart';
import 'package:flamingo/feature/product/data/local/product_local.dart';
import 'package:flamingo/feature/product/data/local/product_local_impl.dart';
import 'package:flamingo/feature/product/data/product_repository.dart';
import 'package:flamingo/feature/product/data/product_repository_impl.dart';
import 'package:flamingo/feature/product/data/remote/product_remote.dart';
import 'package:flamingo/feature/product/data/remote/product_remote_impl.dart';
import 'package:flamingo/feature/product/screen/product-detail/product_detail_app_bar_view_model.dart';
import 'package:flamingo/feature/product/screen/product-detail/product_detail_view_model.dart';
import 'package:flamingo/feature/product/screen/product-listing/min_product_listing_view_model.dart';
import 'package:flamingo/feature/product/screen/product-listing/product_listing_view_model.dart';
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
      authRepository: locator<AuthRepository>(),
    ),
  );
  locator.registerFactory<ProductListingViewModel>(
    () => ProductListingViewModel(
      productRepository: locator<ProductRepository>(),
    ),
  );
  locator.registerFactory<MinProductListingViewModel>(
    () => MinProductListingViewModel(
      productRepository: locator<ProductRepository>(),
    ),
  );
  locator.registerFactory<ProductDetailViewModel>(
    () => ProductDetailViewModel(
      cartRepository: locator<CartRepository>(),
      productRepository: locator<ProductRepository>(),
    ),
  );
  locator.registerFactory<ProductDetailAppBarViewModel>(
    () => ProductDetailAppBarViewModel(),
  );
}
