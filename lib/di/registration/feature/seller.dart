import 'package:flamingo/data/data.dart';
import 'package:flamingo/di/service_names.dart';
import 'package:flamingo/feature/feature.dart';
import 'package:flamingo/feature/seller/data/local/seller_local_impl.dart';
import 'package:flamingo/feature/seller/data/remote/seller_remote.dart';
import 'package:flamingo/feature/seller/data/remote/seller_remote_impl.dart';
import 'package:flamingo/feature/seller/data/seller_repository.dart';
import 'package:flamingo/feature/seller/data/seller_repository_impl.dart';
import 'package:flamingo/feature/seller/screen/manage-seller-profile/manage_seller_profile_view_model.dart';
import 'package:flamingo/feature/seller/screen/seller-profile/seller_profile_view_model.dart';
import 'package:flamingo/feature/seller/data/local/seller_local.dart';
import 'package:get_it/get_it.dart';

void registerSellerFeature(GetIt locator) {
  locator.registerLazySingleton<SellerLocal>(
    () => SellerLocalImpl(
      sharedPrefManager: locator<LocalStorageClient>(
        instanceName: ServiceNames.sharedPrefManager,
      ),
    ),
  );
  locator.registerLazySingleton<SellerRemote>(
    () => SellerRemoteImpl(
      apiClient: locator<ApiClient>(),
    ),
  );
  locator.registerLazySingleton<SellerRepository>(
    () => SellerRepositoryImpl(
      authRepository: locator<AuthRepository>(),
      sellerLocal: locator<SellerLocal>(),
      sellerRemote: locator<SellerRemote>(),
    ),
  );
  locator.registerFactory(
    () => SellerDetailViewModel(
      sellerRepository: locator<SellerRepository>(),
    ),
  );
  locator.registerFactory(
    () => ManageSellerProfileViewModel(
      sellerRepository: locator<SellerRepository>(),
    ),
  );
}
