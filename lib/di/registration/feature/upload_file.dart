import 'package:flamingo/data/data.dart';
import 'package:flamingo/di/service_names.dart';
import 'package:flamingo/feature/upload-file/data/local/upload_file_local.dart';
import 'package:flamingo/feature/upload-file/data/local/upload_file_local_impl.dart';
import 'package:flamingo/feature/upload-file/data/remote/upload_file_remote.dart';
import 'package:flamingo/feature/upload-file/data/remote/upload_file_remote_impl.dart';
import 'package:flamingo/feature/upload-file/data/upload_file_repository.dart';
import 'package:flamingo/feature/upload-file/data/upload_file_repository_impl.dart';
import 'package:flamingo/feature/upload-file/upload_file_view_model.dart';
import 'package:get_it/get_it.dart';

void registerUploadFileFeature(GetIt locator) {
  locator.registerLazySingleton<UploadFileLocal>(
    () => UploadFileLocalImpl(
      sharedPrefManager: locator<LocalStorageClient>(
        instanceName: ServiceNames.sharedPrefManager,
      ),
    ),
  );
  locator.registerLazySingleton<UploadFileRemote>(
    () => UploadFileRemoteImpl(
      apiClient: locator<ApiClient>(),
    ),
  );
  locator.registerLazySingleton<UploadFileRepository>(
    () => UploadFileRepositoryImpl(
      uploadFileLocal: locator<UploadFileLocal>(),
      uploadFileRemote: locator<UploadFileRemote>(),
    ),
  );

  locator.registerFactory<UploadFileViewModel>(
    () => UploadFileViewModel(
      uploadFileRepository: locator<UploadFileRepository>(),
    ),
  );
}
