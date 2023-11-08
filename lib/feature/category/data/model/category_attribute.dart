List<CategoryAttribute> categoryAttributeList(dynamic json) =>
    List<CategoryAttribute>.from(
      json.map(
        (data) => CategoryAttribute.fromJson(data),
      ),
    );

class CategoryAttribute {
  final String id;
  final String name;
  final String description;
  final String categoryId;
  final List<CatgeoryAttributeOption> options;

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
      options: categoryAttributeOptionList(
        json['attributes'],
      ),
    );
  }
}

List<CatgeoryAttributeOption> categoryAttributeOptionList(dynamic json) =>
    List<CatgeoryAttributeOption>.from(
      json.map(
        (data) => CatgeoryAttributeOption.fromJson(data),
      ),
    );

class CatgeoryAttributeOption {
  final String id;
  final String attributeId;
  final String value;
  final String valueType;

  CatgeoryAttributeOption({
    required this.id,
    required this.attributeId,
    required this.value,
    required this.valueType,
  });

  factory CatgeoryAttributeOption.fromJson(Map<String, dynamic> json) {
    return CatgeoryAttributeOption(
      id: json['id'],
      attributeId: json['attributeId'],
      value: json['value'],
      valueType: json['valueType'],
    );
  }
}
