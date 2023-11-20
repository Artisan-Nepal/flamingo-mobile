import 'package:flamingo/data/data.dart';
import 'package:flamingo/di/service_names.dart';
import 'package:flamingo/feature/auth/auth_view_model.dart';
import 'package:flamingo/feature/feature.dart';
import 'package:flamingo/feature/user/data/user_repository.dart';
import 'package:get_it/get_it.dart';

void registerAuthFeature(GetIt locator) {
  locator.registerLazySingleton<AuthLocal>(
    () => AuthLocalImpl(
      sharedPrefManager: locator<LocalStorageClient>(
        instanceName: ServiceNames.sharedPrefManager,
      ),
    ),
  );
  locator.registerLazySingleton<AuthRemote>(
    () => AuthRemoteImpl(
      apiClient: locator<ApiClient>(),
    ),
  );
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authLocal: locator<AuthLocal>(),
      authRemote: locator<AuthRemote>(),
    ),
  );
  locator.registerLazySingleton<AuthViewModel>(
    () => AuthViewModel(
      userRepository: locator<UserRepository>(),
      authRepository: locator<AuthRepository>(),
    ),
  );

  locator.registerFactory<OnboardingViewModel>(
    () => OnboardingViewModel(
      authRepository: locator<AuthRepository>(),
    ),
  );
  locator.registerFactory<LoginViewModel>(
    () => LoginViewModel(
      authRepository: locator<AuthRepository>(),
    ),
  );
}
