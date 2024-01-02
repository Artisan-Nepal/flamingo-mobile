import 'package:flamingo/data/data.dart';
import 'package:flamingo/di/service_names.dart';
import 'package:flamingo/feature/feature.dart';
import 'package:flamingo/feature/search/data/local/search_local.dart';
import 'package:flamingo/feature/search/data/local/search_local_impl.dart';
import 'package:flamingo/feature/search/data/search_repository.dart';
import 'package:flamingo/feature/search/data/search_repository_impl.dart';
import 'package:flamingo/feature/search/data/remote/search_remote.dart';
import 'package:flamingo/feature/search/data/remote/search_remote_impl.dart';
import 'package:flamingo/feature/search/screen/search_view_model.dart';
import 'package:get_it/get_it.dart';

void registerSearchFeature(GetIt locator) {
  locator.registerLazySingleton<SearchLocal>(
    () => SearchLocalImpl(
      sharedPrefManager: locator<LocalStorageClient>(
        instanceName: ServiceNames.sharedPrefManager,
      ),
    ),
  );
  locator.registerLazySingleton<SearchRemote>(
    () => SearchRemoteImpl(
      apiClient: locator<ApiClient>(),
    ),
  );
  locator.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(
      searchLocal: locator<SearchLocal>(),
      searchRemote: locator<SearchRemote>(),
      authRepository: locator<AuthRepository>(),
    ),
  );
  locator.registerFactory<SearchViewModel>(
    () => SearchViewModel(
      searchRepository: locator<SearchRepository>(),
    ),
  );
}
