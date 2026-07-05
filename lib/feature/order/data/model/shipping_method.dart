class ShippingMethod {
  final String id;
  final double duration;
  final int cost;
  final String name;
  final String code;

  ShippingMethod({
    required this.id,
    required this.duration,
    required this.cost,
    required this.name,
    required this.code,
  });

  factory ShippingMethod.fromJson(Map<String, dynamic> json) => ShippingMethod(
        id: json['id'],
        duration: json["duration"].toDouble(),
        cost: json["cost"],
        name: json["name"],
        code: json["code"] ?? '',
      );

  static List<ShippingMethod> fromJsonList(dynamic json) =>
      List<ShippingMethod>.from(
        json.map(
          (data) => ShippingMethod.fromJson(data),
        ),
      );
}
