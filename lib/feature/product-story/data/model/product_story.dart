class ProductStory {
  final String id;
  final String url;
  final bool hasViewed;

  ProductStory({
    required this.id,
    required this.url,
    required this.hasViewed,
  });

  factory ProductStory.fromJson(Map<String, dynamic> json) => ProductStory(
        id: json['id'],
        url: json['url'],
        hasViewed: json['engagements'] == null
            ? false
            : List.from(json['engagements']).isNotEmpty,
      );

  static List<ProductStory> fromJsonList(dynamic json) =>
      List<ProductStory>.from(
        json.map(
          (data) => ProductStory.fromJson(data),
        ),
      );
}
