class PaymentMethod {
  final int paymentModeId;
  final String name;
  final int onlineProcess;
  final int isActive;

  PaymentMethod({
    required this.paymentModeId,
    required this.name,
    required this.onlineProcess,
    required this.isActive,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        paymentModeId: double.parse(json['id'].toString()).toInt(),
        name: json['name'],
        onlineProcess: double.parse(json['online_process'].toString()).toInt(),
        isActive: double.parse(json['is_active'].toString()).toInt(),
      );

  static List<PaymentMethod> fromJsonList(dynamic json) =>
      List<PaymentMethod>.from(
        json.map(
          (data) => PaymentMethod.fromJson(data),
        ),
      );
}
