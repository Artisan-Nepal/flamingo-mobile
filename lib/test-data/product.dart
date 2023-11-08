class Product {
  final String category;
  final String type;
  final String productId;
  final double price;
  final String name;
  final String imageUrl;
  List<String>? hash;
  final String sub_type;
  final String brand;

  Product(
    this.hash, {
    required this.category,
    required this.type,
    required this.productId,
    required this.price,
    required this.name,
    required this.imageUrl,
    required this.sub_type,
    required this.brand,
  });
}
