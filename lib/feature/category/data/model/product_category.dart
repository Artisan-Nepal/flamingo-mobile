class ProductCategory {
  final String id;
  final String name;
  final List<ProductCategory>? children;
  final String? parentId;

  ProductCategory({
    required this.id,
    required this.name,
    required this.parentId,
    this.children,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'],
      name: json['name'],
      parentId: json['parentId'],
      children:
          json['children'] != null ? fromJsonList(json['children']) : null,
    );
  }

  static List<ProductCategory> fromJsonList(dynamic json) =>
      List<ProductCategory>.from(
        json.map(
          (data) => ProductCategory.fromJson(data),
        ),
      );
}
