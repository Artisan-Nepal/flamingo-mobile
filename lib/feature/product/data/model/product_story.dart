class ProductStory {
  final String id;
  final String url;

  ProductStory({
    required this.id,
    required this.url,
  });

  factory ProductStory.fromJson(Map<String, dynamic> json) => ProductStory(
        id: json['id'],
        url: json['url'],
      );

  static List<ProductStory> fromJsonList(dynamic json) =>
      List<ProductStory>.from(
        json.map(
          (data) => ProductStory.fromJson(data),
        ),
      );
}
