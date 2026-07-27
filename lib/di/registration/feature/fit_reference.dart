import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/fit-reference/data/fit_reference_repository.dart';
import 'package:flamingo/feature/fit-reference/data/fit_reference_repository_impl.dart';
import 'package:flamingo/feature/fit-reference/data/remote/fit_reference_remote.dart';
import 'package:flamingo/feature/fit-reference/data/remote/fit_reference_remote_impl.dart';
import 'package:flamingo/feature/fit-reference/screen/fit-reference-listing/fit_reference_listing_view_model.dart';
import 'package:flamingo/feature/fit-reference/screen/manage-fit-reference/manage_fit_reference_view_model.dart';
import 'package:get_it/get_it.dart';

void registerFitReferenceFeature(GetIt locator) {
  locator.registerLazySingleton<FitReferenceRemote>(
    () => FitReferenceRemoteImpl(
      apiClient: locator<ApiClient>(),
    ),
  );
  locator.registerLazySingleton<FitReferenceRepository>(
    () => FitReferenceRepositoryImpl(
      fitReferenceRemote: locator<FitReferenceRemote>(),
    ),
  );
  locator.registerFactory<FitReferenceListingViewModel>(
    () => FitReferenceListingViewModel(
      fitReferenceRepository: locator<FitReferenceRepository>(),
    ),
  );
  locator.registerFactory<ManageFitReferenceViewModel>(
    () => ManageFitReferenceViewModel(
      fitReferenceRepository: locator<FitReferenceRepository>(),
    ),
  );
}
