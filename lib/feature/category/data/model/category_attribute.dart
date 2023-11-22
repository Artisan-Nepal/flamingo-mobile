class CategoryAttribute {
  final String id;
  final String name;
  final String description;
  final String categoryId;
  final List<CategoryAttributeOption> options;

  CategoryAttribute({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
    required this.options,
  });

  factory CategoryAttribute.fromJson(Map<String, dynamic> json) {
    return CategoryAttribute(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      categoryId: json['categoryId'],
      options: CategoryAttributeOption.fromJsonList(
        json['options'],
      ),
    );
  }

  static List<CategoryAttribute> fromJsonList(dynamic json) =>
      List<CategoryAttribute>.from(
        json.map(
          (data) => CategoryAttribute.fromJson(data),
        ),
      );
}

class CategoryAttributeOption {
  final String id;
  final String attributeId;
  final String value;
  final String valueType;

  CategoryAttributeOption({
    required this.id,
    required this.attributeId,
    required this.value,
    required this.valueType,
  });

  factory CategoryAttributeOption.fromJson(Map<String, dynamic> json) {
    return CategoryAttributeOption(
      id: json['id'],
      attributeId: json['attributeId'],
      value: json['value'],
      valueType: json['valueType'],
    );
  }

  static List<CategoryAttributeOption> fromJsonList(dynamic json) =>
      List<CategoryAttributeOption>.from(
        json.map(
          (data) => CategoryAttributeOption.fromJson(data),
        ),
      );
}
