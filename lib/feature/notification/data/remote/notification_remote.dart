import 'package:flamingo/data/model/fetch_response.dart';
import 'package:flamingo/feature/notification/data/model/notification_item.dart';

abstract class NotificationRemote {
  Future<FetchResponse<NotificationItem>> getNotifications();
  Future<void> markRead(String id);
  Future<void> delete(String id);
}
