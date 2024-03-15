import 'package:flamingo/data/data.dart';
import 'package:flamingo/di/service_names.dart';
import 'package:get_it/get_it.dart';

Future<void> registerDataModule(GetIt locator) async {
  var sharedPref = await SharedPrefManager.getInstance();

  // Local Storage Clients
  // locator.registerLazySingleton<LocalStorageClient>(
  //   () => SecureStorageManager(),
  //   instanceName: ServiceNames.secureStorageManager,
  // );
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
}
