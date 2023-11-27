import 'package:flamingo/feature/product/data/model/product.dart';

class WishlistItem {
  final String id;
  final Product product;

  WishlistItem({
    required this.id,
    required this.product,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json['id'],
      product: Product.fromJson(json['product']),
    );
  }

  static List<WishlistItem> fromJsonList(dynamic json) =>
      List<WishlistItem>.from(
        json.map(
          (data) => WishlistItem.fromJson(data),
        ),
      );
}
