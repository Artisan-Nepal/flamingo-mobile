class Product {
  final String id;
  final String price;
  final String brand;
  final String description;
  final List<String> size;
  final String name;
  final List<String> imageurl;
  String? discount;

  Product({
    this.discount,
    required this.price,
    required this.id,
    required this.brand,
    required this.description,
    required this.size,
    required this.name,
    required this.imageurl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        price: json['price'],
        imageurl: json['imageurl'],
        id: json['id'],
        size: json['size'],
        name: json['name'],
        brand: json['brand'],
        description: json['description'],
        discount: json['discount']);
  }
}
