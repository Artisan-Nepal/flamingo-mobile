import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/notification/data/model/notification_item.dart';
import 'package:flamingo/feature/notification/data/remote/notification_remote.dart';

class NotificationRemoteImpl implements NotificationRemote {
  final ApiClient _apiClient;

  NotificationRemoteImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<FetchResponse<NotificationItem>> getNotifications() async {
    final apiResponse = await _apiClient.get(ApiUrls.notificationsSelf);
    return FetchResponse.fromJson(
      apiResponse.data,
      NotificationItem.fromJsonList,
    );
  }

  @override
  Future<void> markRead(String id) async {
    await _apiClient.post(ApiUrls.notificationRead.replaceFirst(':id', id));
  }

  @override
  Future<void> delete(String id) async {
    await _apiClient.delete(ApiUrls.notificationDelete.replaceFirst(':id', id));
  }
}
