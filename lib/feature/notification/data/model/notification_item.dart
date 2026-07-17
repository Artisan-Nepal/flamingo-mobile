class NotificationItem {
  final String id;
  final String title;
  final String? description;
  final String notificationCode;
  // Mutable so the view model can flip this in place after a successful
  // mark-read call, instead of refetching the whole list just to update one
  // flag.
  bool hasRead;
  final DateTime createdAt;
  // { type: 'order' | 'promo', orderId?, bannerId?, code? } - same shape the
  // push payload's `data` field carries, so tap-routing logic can be shared.
  final Map<String, dynamic> metadata;

  NotificationItem({
    required this.id,
    required this.title,
    this.description,
    required this.notificationCode,
    required this.hasRead,
    required this.createdAt,
    required this.metadata,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      NotificationItem(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        notificationCode: json['notificationCode'],
        hasRead: json['hasRead'] ?? false,
        createdAt: DateTime.parse(json['createdAt']),
        metadata: json['metadata'] is Map
            ? Map<String, dynamic>.from(json['metadata'])
            : {},
      );

  static List<NotificationItem> fromJsonList(dynamic json) =>
      List<NotificationItem>.from(
        json.map((data) => NotificationItem.fromJson(data)),
      );
}
