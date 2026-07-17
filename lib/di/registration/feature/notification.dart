import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/notification/data/notification_repository.dart';
import 'package:flamingo/feature/notification/data/notification_repository_impl.dart';
import 'package:flamingo/feature/notification/data/remote/notification_remote.dart';
import 'package:flamingo/feature/notification/data/remote/notification_remote_impl.dart';
import 'package:flamingo/feature/notification/notification_view_model.dart';
import 'package:get_it/get_it.dart';

void registerNotificationFeature(GetIt locator) {
  locator.registerLazySingleton<NotificationRemote>(
    () => NotificationRemoteImpl(
      apiClient: locator<ApiClient>(),
    ),
  );
  locator.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(
      remote: locator<NotificationRemote>(),
    ),
  );
  // Singleton (not factory, unlike PromoBannerViewModel) - registered once at
  // the app root (see app.dart) so the unread badge stays in sync everywhere
  // rather than each screen getting its own disconnected instance.
  locator.registerLazySingleton<NotificationViewModel>(
    () => NotificationViewModel(
      repository: locator<NotificationRepository>(),
    ),
  );
}
