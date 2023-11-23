import 'package:flamingo/data/data.dart';
import 'package:flamingo/di/service_names.dart';
import 'package:flamingo/feature/address/data/address_repository.dart';
import 'package:flamingo/feature/address/data/address_repository_impl.dart';
import 'package:flamingo/feature/address/data/local/address_local.dart';
import 'package:flamingo/feature/address/data/local/address_local_impl.dart';
import 'package:flamingo/feature/address/data/remote/address_remote.dart';
import 'package:flamingo/feature/address/data/remote/address_remote_impl.dart';
import 'package:get_it/get_it.dart';

void registerAddressFeature(GetIt locator) {
  locator.registerLazySingleton<AddressLocal>(
    () => AddressLocalImpl(
      sharedPrefManager: locator<LocalStorageClient>(
        instanceName: ServiceNames.sharedPrefManager,
      ),
    ),
  );
  locator.registerLazySingleton<AddressRemote>(
    () => AddressRemoteImpl(
      apiClient: locator<ApiClient>(),
    ),
  );
  locator.registerLazySingleton<AddressRepository>(
    () => AddressRepositoryImpl(
      addressLocal: locator<AddressLocal>(),
      addressRemote: locator<AddressRemote>(),
    ),
  );
}
