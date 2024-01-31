import 'package:flamingo/feature/product-story/data/model/product_story.dart';

class GroupedProductStory {
  final String productId;
  final String productImage;
  final String productTitle;
  final List<ProductStory> productStories;

  GroupedProductStory({
    required this.productId,
    required this.productStories,
    required this.productImage,
    required this.productTitle,
  });

  factory GroupedProductStory.fromJson(Map<String, dynamic> json) =>
      GroupedProductStory(
        productId: json['productId'],
        productImage: json['productImage'],
        productTitle: json['productTitle'],
        productStories: ProductStory.fromJsonList(json['productStories']),
      );

  static List<GroupedProductStory> fromJsonList(dynamic json) =>
      List<GroupedProductStory>.from(
        json.map(
          (data) => GroupedProductStory.fromJson(data),
        ),
      );
}
