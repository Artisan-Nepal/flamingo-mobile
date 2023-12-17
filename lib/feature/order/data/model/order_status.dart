class OrderStatus {
  final String id;
  final String name;
  final String description;
  final int sequenceNumber;

  OrderStatus({
    required this.id,
    required this.name,
    required this.description,
    required this.sequenceNumber,
  });

  factory OrderStatus.fromJson(Map<String, dynamic> json) => OrderStatus(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        sequenceNumber: json['sequenceNumber'],
      );
}
