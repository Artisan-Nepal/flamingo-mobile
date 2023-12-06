import 'package:flamingo/feature/product/data/model/product.dart';

class CartItem {
  final String id;
  final int quantity;
  final CartItemProduct product;
  final ProductVariant productVariant;

  CartItem({
    required this.id,
    required this.quantity,
    required this.product,
    required this.productVariant,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: json['id'],
        quantity: json['quantity'],
        product: CartItemProduct.fromJson(json['productVariant']['product']),
        productVariant: ProductVariant.fromJson(json['productVariant']),
      );

  static List<CartItem> fromJsonList(dynamic json) => List<CartItem>.from(
        json.map(
          (data) => CartItem.fromJson(data),
        ),
      );
}

class CartItemProduct {
  final String id;
  final String title;
  final String body;
  final String status;

  CartItemProduct({
    required this.id,
    required this.title,
    required this.body,
    required this.status,
  });

  factory CartItemProduct.fromJson(Map<String, dynamic> json) =>
      CartItemProduct(
        id: json['id'],
        title: json['title'],
        body: json['body'],
        status: json['status'],
      );
}
