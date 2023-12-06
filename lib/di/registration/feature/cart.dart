import 'package:flamingo/data/data.dart';
import 'package:flamingo/di/service_names.dart';
import 'package:flamingo/feature/auth/auth.dart';
import 'package:flamingo/feature/cart/data/cart_repository.dart';
import 'package:flamingo/feature/cart/data/cart_repository_impl.dart';
import 'package:flamingo/feature/cart/data/local/cart_local.dart';
import 'package:flamingo/feature/cart/data/local/cart_local_impl.dart';
import 'package:flamingo/feature/cart/data/remote/cart_remote.dart';
import 'package:flamingo/feature/cart/data/remote/cart_remote_impl.dart';
import 'package:flamingo/feature/cart/screen/cart-listing/cart_listing_view_model.dart';
import 'package:get_it/get_it.dart';

void registerCartFeature(GetIt locator) {
  locator.registerLazySingleton<CartLocal>(
    () => CartLocalImpl(
      sharedPrefManager: locator<LocalStorageClient>(
        instanceName: ServiceNames.sharedPrefManager,
      ),
    ),
  );
  locator.registerLazySingleton<CartRemote>(
    () => CartRemoteImpl(
      apiClient: locator<ApiClient>(),
    ),
  );
  locator.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(
        cartLocal: locator<CartLocal>(),
        cartRemote: locator<CartRemote>(),
        authRepository: locator<AuthRepository>()),
  );
  locator.registerFactory<CartListingViewModel>(
    () => CartListingViewModel(cartRepository: locator<CartRepository>()),
  );
}
