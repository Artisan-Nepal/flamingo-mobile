class ProductSize {
  final String id;
  final String name;
  final String description;
  final List<ProductSizeOption> options;

  ProductSize({
    required this.id,
    required this.name,
    required this.description,
    required this.options,
  });

  factory ProductSize.fromJson(Map<String, dynamic> json) {
    return ProductSize(
      id: json['id'],
      description: json['description'],
      name: json['name'],
      options: ProductSizeOption.fromJsonList(json['productSizeOptions']),
    );
  }

  static List<ProductSize> fromJsonList(dynamic json) => List<ProductSize>.from(
        json.map(
          (data) => ProductSize.fromJson(data),
        ),
      );
}

class ProductSizeOption {
  final String id;
  final String productSizeId;
  final String value;

  ProductSizeOption({
    required this.id,
    required this.productSizeId,
    required this.value,
  });

  factory ProductSizeOption.fromJson(Map<String, dynamic> json) {
    return ProductSizeOption(
      id: json['id'],
      productSizeId: json['productSizeId'],
      value: json['value'],
    );
  }

  static List<ProductSizeOption> fromJsonList(dynamic json) =>
      List<ProductSizeOption>.from(
        json.map(
          (data) => ProductSizeOption.fromJson(data),
        ),
      );
}
