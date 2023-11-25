import 'package:flamingo/data/data.dart';
import 'package:flamingo/di/service_names.dart';
import 'package:flamingo/feature/wishlist/data/local/wishlist_local.dart';
import 'package:flamingo/feature/wishlist/data/local/wishlist_local_impl.dart';
import 'package:flamingo/feature/wishlist/data/remote/wishilst_remote.dart';
import 'package:flamingo/feature/wishlist/data/remote/wishlist_remote_impl.dart';
import 'package:flamingo/feature/wishlist/data/wishlist_repository.dart';
import 'package:flamingo/feature/wishlist/data/wishlist_repository_impl.dart';
import 'package:flamingo/feature/wishlist/wishlist_view_model.dart';
import 'package:get_it/get_it.dart';

void registerWishlistFeature(GetIt locator) {
  locator.registerLazySingleton<WishlistLocal>(
    () => WishlistLocalImpl(
      sharedPrefManager: locator<LocalStorageClient>(
        instanceName: ServiceNames.sharedPrefManager,
      ),
    ),
  );
  locator.registerLazySingleton<WishlistRemote>(
    () => WishlistRemoteImpl(
      apiClient: locator<ApiClient>(),
    ),
  );
  locator.registerLazySingleton<WishlistRepository>(
    () => WishlistRepositoryImpl(
      wishlistLocal: locator<WishlistLocal>(),
      wishlistRemote: locator<WishlistRemote>(),
    ),
  );
  locator.registerFactory<WishlistViewModel>(
    () => WishlistViewModel(),
  );
}
