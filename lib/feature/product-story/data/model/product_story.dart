class ProductStory {
  final String id;
  final String url;
  final bool hasViewed;
  final String? productId;

  ProductStory({
    required this.id,
    required this.url,
    required this.hasViewed,
    this.productId,
  });

  factory ProductStory.fromJson(Map<String, dynamic> json) {
    return ProductStory(
      id: json['id'],
      url: json['url'],
      productId: json['productId'],
      hasViewed: json['engagements'] == null
          ? false
          : List.from(json['engagements']).isNotEmpty,
    );
  }

  static List<ProductStory> fromJsonList(dynamic json) =>
      List<ProductStory>.from(
        json.map(
          (data) => ProductStory.fromJson(data),
        ),
      );
}
