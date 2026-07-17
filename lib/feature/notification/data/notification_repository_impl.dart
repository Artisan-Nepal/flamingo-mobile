import 'package:flamingo/data/model/fetch_response.dart';
import 'package:flamingo/feature/notification/data/model/notification_item.dart';
import 'package:flamingo/feature/notification/data/notification_repository.dart';
import 'package:flamingo/feature/notification/data/remote/notification_remote.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemote _remote;

  NotificationRepositoryImpl({required NotificationRemote remote})
      : _remote = remote;

  @override
  Future<FetchResponse<NotificationItem>> getNotifications() async =>
      await _remote.getNotifications();

  @override
  Future<void> markRead(String id) async => await _remote.markRead(id);

  @override
  Future<void> delete(String id) async => await _remote.delete(id);
}
