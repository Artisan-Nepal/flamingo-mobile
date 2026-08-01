import 'package:flamingo/data/data.dart';
import 'package:flamingo/di/service_names.dart';
import 'package:flamingo/feature/auth/screen/login/login_screen.dart';
import 'package:flamingo/shared/helper/navigation_helper.dart';
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

  // Encrypted store for the auth token (Keychain/Keystore), with one-time
  // migration from the old plaintext SharedPreferences location.
  locator.registerLazySingleton<SecureTokenStore>(
    () => SecureTokenStore(
      legacySharedPref: locator<LocalStorageClient>(
        instanceName: ServiceNames.sharedPrefManager,
      ),
    ),
  );

  // Remote Clients. On an authenticated 401 (stale/invalid token), the client
  // clears the token and calls back here to route the user to login. The guard
  // stops parallel 401s (e.g. a dashboard's simultaneous calls) from stacking
  // multiple redirects; it resets once the user leaves the login screen.
  var redirectingToLogin = false;
  locator.registerLazySingleton<ApiClient>(
    () => DioApiClientImpl(
      tokenStore: locator<SecureTokenStore>(),
      onUnauthorized: () async {
        if (redirectingToLogin) return;
        redirectingToLogin = true;
        await NavigationHelper.pushAndReplaceAllGlobal(LoginScreen());
        redirectingToLogin = false;
      },
    ),
  );
}
