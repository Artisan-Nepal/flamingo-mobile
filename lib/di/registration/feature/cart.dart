import 'package:flamingo/data/data.dart';
import 'package:flamingo/di/service_names.dart';
import 'package:flamingo/feature/cart/data/cart_repository.dart';
import 'package:flamingo/feature/cart/data/cart_repository_impl.dart';
import 'package:flamingo/feature/cart/data/local/cart_local.dart';
import 'package:flamingo/feature/cart/data/local/cart_local_impl.dart';
import 'package:flamingo/feature/cart/data/remote/cart_remote.dart';
import 'package:flamingo/feature/cart/data/remote/cart_remote_impl.dart';
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
    ),
  );
}
