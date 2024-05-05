import 'package:flamingo/%20notification/notification.dart';
import 'package:flamingo/data/local/local.dart';
import 'package:flamingo/di/service_names.dart';
import 'package:flamingo/feature/feature.dart';
import 'package:flamingo/navigation/navigation_service.dart';
import 'package:get_it/get_it.dart';

void registerServices(GetIt locator) {
  // Theme
  locator.registerLazySingleton<ThemeLocal>(
    () => ThemeLocalImpl(
      sharedPrefManager: locator<LocalStorageClient>(
        instanceName: ServiceNames.sharedPrefManager,
      ),
    ),
  );
  locator.registerLazySingleton<ThemeRepository>(
    () => ThemeRepositoryImpl(
      themeLocal: locator<ThemeLocal>(),
    ),
  );
  locator.registerLazySingleton<ThemeService>(
    () => ThemeService(
      themeRepository: locator<ThemeRepository>(),
    ),
  );

  // Navigation
  locator.registerLazySingleton(
    () => NavigationService(
      sharedPrefManager: locator<LocalStorageClient>(
        instanceName: ServiceNames.sharedPrefManager,
      ),
    ),
  );

  locator.registerLazySingleton(
    () => NotificationService(),
  );
}
