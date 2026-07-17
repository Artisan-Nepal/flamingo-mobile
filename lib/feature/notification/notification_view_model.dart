import 'package:flamingo/data/model/fetch_response.dart';
import 'package:flamingo/feature/notification/data/model/notification_item.dart';
import 'package:flamingo/feature/notification/data/notification_repository.dart';
import 'package:flamingo/shared/shared.dart';
import 'package:flutter/material.dart';

class NotificationViewModel extends ChangeNotifier {
  final NotificationRepository _repository;

  NotificationViewModel({required NotificationRepository repository})
      : _repository = repository;

  Response<FetchResponse<NotificationItem>> _getNotificationsUseCase =
      Response<FetchResponse<NotificationItem>>();
  Response<FetchResponse<NotificationItem>> get getNotificationsUseCase =>
      _getNotificationsUseCase;

  int get unreadCount =>
      _getNotificationsUseCase.data?.rows.where((n) => !n.hasRead).length ??
      0;

  void _setNotifications(Response<FetchResponse<NotificationItem>> response) {
    _getNotificationsUseCase = response;
    notifyListeners();
  }

  Future<void> getNotifications() async {
    try {
      _setNotifications(Response.loading());
      final response = await _repository.getNotifications();
      _setNotifications(Response.complete(response));
    } catch (exception) {
      _setNotifications(Response.error(exception));
    }
  }

  // Optimistic - flips the local flag immediately (so the badge/list update
  // without waiting on a round trip) and lets the API call fail silently in
  // the background; a stale "read" flag if the call fails is low-stakes and
  // self-corrects on the next getNotifications().
  Future<void> markRead(NotificationItem notification) async {
    if (notification.hasRead) return;
    notification.hasRead = true;
    notifyListeners();
    try {
      await _repository.markRead(notification.id);
    } catch (_) {}
  }

  // Clears the unread state for every notification at once. Same optimistic
  // strategy as [markRead]: flip all the local flags immediately so the glow
  // and badge disappear, then fire the per-notification calls in the
  // background (there is no bulk endpoint) and let any failure self-correct on
  // the next getNotifications().
  Future<void> markAllRead() async {
    final unread = _getNotificationsUseCase.data?.rows
            .where((n) => !n.hasRead)
            .toList() ??
        [];
    if (unread.isEmpty) return;
    for (final notification in unread) {
      notification.hasRead = true;
    }
    notifyListeners();
    await Future.wait(
      unread.map((n) async {
        try {
          await _repository.markRead(n.id);
        } catch (_) {}
      }),
    );
  }

  // Optimistically removes a notification from the local list (so the swipe
  // feels instant) and deletes it on the server in the background. If the call
  // fails the item reappears on the next getNotifications().
  Future<void> delete(NotificationItem notification) async {
    _getNotificationsUseCase.data?.rows
        .removeWhere((n) => n.id == notification.id);
    notifyListeners();
    try {
      await _repository.delete(notification.id);
    } catch (_) {}
  }
}
