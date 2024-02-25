import 'package:flamingo/feature/product/data/model/product_detail.dart';

class WishlistItem {
  final String id;
  final ProductDetail product;

  WishlistItem({
    required this.id,
    required this.product,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json['id'],
      product: ProductDetail.fromJson(json['product']),
    );
  }

  static List<WishlistItem> fromJsonList(dynamic json) =>
      List<WishlistItem>.from(
        json.map(
          (data) => WishlistItem.fromJson(data),
        ),
      );
}
