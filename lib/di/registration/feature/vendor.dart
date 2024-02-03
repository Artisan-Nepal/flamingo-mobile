import 'package:flamingo/data/data.dart';
import 'package:flamingo/di/service_names.dart';
import 'package:flamingo/feature/feature.dart';
import 'package:flamingo/feature/vendor/data/local/vendor_local.dart';
import 'package:flamingo/feature/vendor/data/local/vendor_local_impl.dart';
import 'package:flamingo/feature/vendor/data/remote/vendor_remote.dart';
import 'package:flamingo/feature/vendor/data/remote/vendor_remote_impl.dart';
import 'package:flamingo/feature/vendor/data/vendor_repository.dart';
import 'package:flamingo/feature/vendor/data/vendor_repository_impl.dart';
import 'package:flamingo/feature/vendor/favourite_vendor_view_model.dart';
import 'package:flamingo/feature/vendor/screen/vendor-profile/vendor_profile_view_model.dart';
import 'package:flamingo/feature/vendor/update_favourite_vendor_view_model.dart';
import 'package:flamingo/feature/vendor/vendor_listing_view_model.dart';
import 'package:get_it/get_it.dart';

void registerVendorFeature(GetIt locator) {
  locator.registerLazySingleton<VendorLocal>(
    () => VendorLocalImpl(
      sharedPrefManager: locator<LocalStorageClient>(
        instanceName: ServiceNames.sharedPrefManager,
      ),
    ),
  );
  locator.registerLazySingleton<VendorRemote>(
    () => VendorRemoteImpl(
      apiClient: locator<ApiClient>(),
    ),
  );
  locator.registerLazySingleton<VendorRepository>(
    () => VendorRepositoryImpl(
      authRepository: locator<AuthRepository>(),
      vendorLocal: locator<VendorLocal>(),
      vendorRemote: locator<VendorRemote>(),
    ),
  );
  locator.registerFactory(
    () => VendorListingViewModel(
      vendorRepository: locator<VendorRepository>(),
    ),
  );
  locator.registerLazySingleton<FavouriteVendorViewModel>(
    () => FavouriteVendorViewModel(
      vendorRepository: locator<VendorRepository>(),
    ),
  );
  locator.registerFactory<UpdateFavouriteVendorViewModel>(
    () => UpdateFavouriteVendorViewModel(
      vendorRepository: locator<VendorRepository>(),
    ),
  );
  locator.registerFactory<VendorProfileViewModel>(
    () => VendorProfileViewModel(
      vendorRepository: locator<VendorRepository>(),
    ),
  );
}
