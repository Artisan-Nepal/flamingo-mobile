class Cart {
  final String id;

  Cart({
    required this.id,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
    );
  }

  static List<Cart> fromJsonList(dynamic json) => List<Cart>.from(
        json.map(
          (data) => Cart.fromJson(data),
        ),
      );
}
