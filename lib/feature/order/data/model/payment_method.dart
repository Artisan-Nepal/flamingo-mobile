class PaymentMethod {
  final String id;
  final String name;
  final String code;

  PaymentMethod({
    required this.id,
    required this.name,
    required this.code,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        id: json['id'],
        name: json['name'],
        code: json['code'],
      );

  static List<PaymentMethod> fromJsonList(dynamic json) =>
      List<PaymentMethod>.from(
        json.map(
          (data) => PaymentMethod.fromJson(data),
        ),
      );
}
