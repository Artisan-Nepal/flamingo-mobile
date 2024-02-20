import 'package:flamingo/data/data.dart';
import 'package:flamingo/di/service_names.dart';
import 'package:flamingo/feature/advertisement/advertisement_listing_view_model.dart';
import 'package:flamingo/feature/advertisement/data/advertisement_repository.dart';
import 'package:flamingo/feature/advertisement/data/advertisement_repository_impl.dart';
import 'package:flamingo/feature/advertisement/data/local/advertisement_local.dart';
import 'package:flamingo/feature/advertisement/data/local/advertisement_local_impl.dart';
import 'package:flamingo/feature/advertisement/data/remote/advertisement_remote.dart';
import 'package:flamingo/feature/advertisement/data/remote/advertisement_remote_impl.dart';
import 'package:flamingo/feature/advertisement/screen/advertisement_app_bar_view_model.dart';
import 'package:flamingo/feature/feature.dart';
import 'package:get_it/get_it.dart';

void registerAdvertisementFeature(GetIt locator) {
  locator.registerLazySingleton<AdvertisementLocal>(
    () => AdvertisementLocalImpl(
      sharedPrefManager: locator<LocalStorageClient>(
        instanceName: ServiceNames.sharedPrefManager,
      ),
    ),
  );
  locator.registerLazySingleton<AdvertisementRemote>(
    () => AdvertisementRemoteImpl(
      apiClient: locator<ApiClient>(),
    ),
  );
  locator.registerLazySingleton<AdvertisementRepository>(
    () => AdvertisementRepositoryImpl(
      advertisementLocal: locator<AdvertisementLocal>(),
      advertisementRemote: locator<AdvertisementRemote>(),
      authRepository: locator<AuthRepository>(),
    ),
  );

  locator.registerFactory<AdvertisementListingViewModel>(
    () => AdvertisementListingViewModel(
      advertisementRepository: locator<AdvertisementRepository>(),
    ),
  );
  locator.registerFactory<AdvertisementAppBarViewModel>(
    () => AdvertisementAppBarViewModel(),
  );
}
