List<ProductCategory> categoryList(dynamic json) => List<ProductCategory>.from(
      json.map(
        (data) => ProductCategory.fromJson(data),
      ),
    );

class ProductCategory {
  final String id;
  final String name;
  final List<ProductCategory>? children;

  ProductCategory({
    required this.id,
    required this.name,
    this.children,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'],
      name: json['name'],
      children:
          json['children'] != null ? categoryList(json['children']) : null,
    );
  }
}
