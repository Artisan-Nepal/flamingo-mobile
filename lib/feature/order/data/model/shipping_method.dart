class ShippingMethod {
  final int id;
  final String duration;
  final int cost;
  final String title;

  ShippingMethod({
    required this.id,
    required this.duration,
    required this.cost,
    required this.title,
  });

  factory ShippingMethod.fromJson(Map<String, dynamic> json) => ShippingMethod(
        id: json["id"],
        duration: json["duration"],
        cost: double.parse(json["cost"].toString()).toInt(),
        title: json["title"],
      );

  static List<ShippingMethod> fromJsonList(dynamic json) =>
      List<ShippingMethod>.from(
        json.map(
          (data) => ShippingMethod.fromJson(data),
        ),
      );
}
