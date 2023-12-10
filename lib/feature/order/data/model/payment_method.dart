class PaymentMethod {
  final String id;
  final String name;

  PaymentMethod({
    required this.id,
    required this.name,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        id: json['id'],
        name: json['name'],
      );

  static List<PaymentMethod> fromJsonList(dynamic json) =>
      List<PaymentMethod>.from(
        json.map(
          (data) => PaymentMethod.fromJson(data),
        ),
      );
}
