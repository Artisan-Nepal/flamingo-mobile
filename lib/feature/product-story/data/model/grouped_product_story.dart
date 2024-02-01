import 'package:flamingo/feature/product-story/data/model/product_story.dart';
import 'package:flamingo/feature/vendor/data/model/vendor.dart';

class GroupedProductStory {
  final Vendor vendor;
  final List<GroupedProductStoryItem> items;

  GroupedProductStory({
    required this.vendor,
    required this.items,
  });

  factory GroupedProductStory.fromJson(Map<String, dynamic> json) =>
      GroupedProductStory(
        vendor: Vendor.fromJson(json['vendor']),
        items: GroupedProductStoryItem.fromJsonList(json['items']),
      );

  static List<GroupedProductStory> fromJsonList(dynamic json) =>
      List<GroupedProductStory>.from(
        json.map(
          (data) => GroupedProductStory.fromJson(data),
        ),
      );
}

class GroupedProductStoryItem {
  final String productId;
  final String productName;
  final String productImage;
  final ProductStory story;

  GroupedProductStoryItem({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.story,
  });

  factory GroupedProductStoryItem.fromJson(Map<String, dynamic> json) =>
      GroupedProductStoryItem(
        productId: json['productId'],
        productImage: json['productImage'],
        productName: json['productName'],
        story: ProductStory.fromJson(json['story']),
      );

  static List<GroupedProductStoryItem> fromJsonList(dynamic json) =>
      List<GroupedProductStoryItem>.from(
        json.map(
          (data) => GroupedProductStoryItem.fromJson(data),
        ),
      );
}
