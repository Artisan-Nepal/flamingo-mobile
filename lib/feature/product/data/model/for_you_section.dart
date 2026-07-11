import 'package:flamingo/feature/product/data/model/product_detail.dart';

/// One row of the personalized "For You" home feed: a category header and the
/// products in it. Mirrors the backend's /products/for-you response, which
/// groups products by the categories the user has interacted with.
class ForYouSection {
  final String categoryId;
  final String categoryName;
  final List<ProductDetail> products;

  ForYouSection({
    required this.categoryId,
    required this.categoryName,
    required this.products,
  });

  factory ForYouSection.fromJson(Map<String, dynamic> json) {
    final category = (json['category'] as Map<String, dynamic>?) ?? const {};
    return ForYouSection(
      categoryId: category['id'] as String? ?? '',
      categoryName: category['name'] as String? ?? '',
      products: ProductDetail.fromJsonList(json['products'] ?? []),
    );
  }

  static List<ForYouSection> fromJsonList(dynamic json) {
    if (json is! List) return [];
    return json
        .map((e) => ForYouSection.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
