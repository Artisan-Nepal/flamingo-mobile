import 'package:flamingo/data/data.dart';
import 'package:flamingo/di/service_names.dart';
import 'package:flamingo/feature/dashboard/screen/account/change_display_picture_view_model.dart';
import 'package:flamingo/feature/feature.dart';
import 'package:flamingo/feature/upload-file/data/upload_file_repository.dart';
import 'package:flamingo/feature/user/data/local/user_local.dart';
import 'package:flamingo/feature/user/data/local/user_local_impl.dart';
import 'package:flamingo/feature/user/data/remote/user_remote.dart';
import 'package:flamingo/feature/user/data/remote/user_remote_impl.dart';
import 'package:flamingo/feature/user/data/user_repository.dart';
import 'package:flamingo/feature/user/data/user_repository_impl.dart';
import 'package:flamingo/feature/user/update_user_view_model.dart';
import 'package:get_it/get_it.dart';

void registerUserFeature(GetIt locator) {
  locator.registerLazySingleton<UserLocal>(
    () => UserLocalImpl(
      sharedPrefManager: locator<LocalStorageClient>(
        instanceName: ServiceNames.sharedPrefManager,
      ),
    ),
  );
  locator.registerLazySingleton<UserRemote>(
    () => UserRemoteImpl(
      apiClient: locator<ApiClient>(),
    ),
  );
  locator.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      authRepository: locator<AuthRepository>(),
      userLocal: locator<UserLocal>(),
      userRemote: locator<UserRemote>(),
    ),
  );
  locator.registerFactory(
    () => UpdateUserViewModel(
      userRepository: locator<UserRepository>(),
    ),
  );
  locator.registerFactory(
    () => ChangeDisplayPictureViewModel(
      uploadFileRepository: locator<UploadFileRepository>(),
      userRepository: locator<UserRepository>(),
    ),
  );
}
