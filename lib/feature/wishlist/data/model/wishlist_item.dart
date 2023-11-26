class WishlistItem {
  final String id;
  final String productName;
  final int productPrice;
  final String productImage;
  final String vendor;

  WishlistItem({
    required this.id,
    required this.productImage,
    required this.productName,
    required this.productPrice,
    required this.vendor,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json['id'],
      productName: json['product']['title'],
      productPrice: json['product']['variants'][0]['price'],
      productImage: json['product']['variants'][0]['image'],
      vendor: json['product']['vendor']['storeName'],
    );
  }

  static List<WishlistItem> fromJsonList(dynamic json) =>
      List<WishlistItem>.from(
        json.map(
          (data) => WishlistItem.fromJson(data),
        ),
      );
}
