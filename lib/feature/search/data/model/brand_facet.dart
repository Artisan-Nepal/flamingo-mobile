/// A brand option for the search results filter, from
/// POST /products/search/brands (distinct brands matching the keyword).
class BrandFacet {
  final String sellerId;
  final String storeName;

  const BrandFacet({required this.sellerId, required this.storeName});

  factory BrandFacet.fromJson(Map<String, dynamic> json) => BrandFacet(
        sellerId: json['sellerId'],
        storeName: json['storeName'] ?? '',
      );

  static List<BrandFacet> fromJsonList(dynamic data) =>
      ((data as List?) ?? []).map((e) => BrandFacet.fromJson(e)).toList();
}
