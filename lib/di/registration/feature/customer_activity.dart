import 'package:flamingo/data/data.dart';
import 'package:flamingo/di/service_names.dart';
import 'package:flamingo/feature/customer-activity/customer_activity_view_model.dart';
import 'package:flamingo/feature/customer-activity/data/customer_activity_repository.dart';
import 'package:flamingo/feature/customer-activity/data/customer_activity_repository_impl.dart';
import 'package:flamingo/feature/customer-activity/data/local/customer_activity_local.dart';
import 'package:flamingo/feature/customer-activity/data/local/customer_activity_local_impl.dart';
import 'package:flamingo/feature/customer-activity/data/remote/customer_activity_remote.dart';
import 'package:flamingo/feature/customer-activity/data/remote/customer_activity_remote_impl.dart';
import 'package:flamingo/feature/feature.dart';
import 'package:get_it/get_it.dart';

void registerCustomerActivityFeature(GetIt locator) {
  locator.registerLazySingleton<CustomerActivityLocal>(
    () => CustomerActivityLocalImpl(
      sharedPrefManager: locator<LocalStorageClient>(
        instanceName: ServiceNames.sharedPrefManager,
      ),
    ),
  );
  locator.registerLazySingleton<CustomerActivityRemote>(
    () => CustomerActivityRemoteImpl(
      apiClient: locator<ApiClient>(),
    ),
  );
  locator.registerLazySingleton<CustomerActivityRepository>(
    () => CustomerActivityRepositoryImpl(
      authRepository: locator<AuthRepository>(),
      customerActivityLocal: locator<CustomerActivityLocal>(),
      customerActivityRemote: locator<CustomerActivityRemote>(),
    ),
  );
  locator.registerLazySingleton(
    () => CustomerActivityViewModel(
      customerActivityRepository: locator<CustomerActivityRepository>(),
    ),
  );
}
