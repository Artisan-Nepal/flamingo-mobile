import 'package:flamingo/feature/order/data/model/order_status.dart';

class OrderStatusLog {
  final String id;
  final OrderStatus status;
  final DateTime timestamp;

  OrderStatusLog({
    required this.id,
    required this.status,
    required this.timestamp,
  });

  factory OrderStatusLog.fromJson(Map<String, dynamic> json) => OrderStatusLog(
        id: json['id'],
        status: OrderStatus.fromJson(json['orderStatus']),
        timestamp: DateTime.parse(json['timestamp']),
      );

  static List<OrderStatusLog> fromJsonList(dynamic json) =>
      List<OrderStatusLog>.from(
        json.map(
          (data) => OrderStatusLog.fromJson(data),
        ),
      );
}
