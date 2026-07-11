import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/promo-banner/data/promo_banner_repository.dart';
import 'package:flamingo/feature/promo-banner/data/promo_banner_repository_impl.dart';
import 'package:flamingo/feature/promo-banner/data/remote/promo_banner_remote.dart';
import 'package:flamingo/feature/promo-banner/data/remote/promo_banner_remote_impl.dart';
import 'package:flamingo/feature/promo-banner/promo_banner_view_model.dart';
import 'package:get_it/get_it.dart';

void registerPromoBannerFeature(GetIt locator) {
  locator.registerLazySingleton<PromoBannerRemote>(
    () => PromoBannerRemoteImpl(
      apiClient: locator<ApiClient>(),
    ),
  );
  locator.registerLazySingleton<PromoBannerRepository>(
    () => PromoBannerRepositoryImpl(
      remote: locator<PromoBannerRemote>(),
    ),
  );
  locator.registerFactory<PromoBannerViewModel>(
    () => PromoBannerViewModel(
      repository: locator<PromoBannerRepository>(),
    ),
  );
}
