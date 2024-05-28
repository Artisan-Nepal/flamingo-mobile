import 'package:flamingo/feature/product/data/model/product_detail.dart';

class Product {
  final String productId;
  final String title;
  final String image;
  final int quantity;
  final int price;
  final String sellerStoreName;
  final String? sellerId;
  final ProductDetail? product;

  Product({
    required this.productId,
    required this.title,
    required this.quantity,
    required this.price,
    required this.image,
    required this.sellerStoreName,
    this.sellerId,
    this.product,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['productId'],
      title: json['title'],
      image: json['imageUrl'],
      quantity: json['quantity'],
      price: json['price'],
      sellerStoreName: json['sellerStoreName'],
      sellerId: json['sellerId'],
    );
  }

  static List<Product> fromJsonList(dynamic json) => List<Product>.from(
        json.map(
          (data) => Product.fromJson(data),
        ),
      );
}
