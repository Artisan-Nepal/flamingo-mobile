/// Filter options a brand actually stocks, from GET /products/seller/:id/facets.
/// Drives the "Choose category" / "Choose size" multi-selects on the brand page.
class CategoryFacet {
  final String id;
  final String name;

  const CategoryFacet({required this.id, required this.name});

  factory CategoryFacet.fromJson(Map<String, dynamic> json) => CategoryFacet(
        id: json['id'],
        name: json['name'],
      );
}

class SellerFacets {
  final List<CategoryFacet> categories;
  final List<String> sizes;

  const SellerFacets({this.categories = const [], this.sizes = const []});

  factory SellerFacets.fromJson(Map<String, dynamic> json) => SellerFacets(
        categories: ((json['categories'] as List?) ?? [])
            .map((e) => CategoryFacet.fromJson(e))
            .toList(),
        sizes: ((json['sizes'] as List?) ?? []).map((e) => e.toString()).toList(),
      );

  // Categories can repeat by name across the taxonomy (e.g. two "Belts" under
  // different parents); collapse to the first id per name for a clean list.
  List<CategoryFacet> get dedupedCategories {
    final seen = <String>{};
    final out = <CategoryFacet>[];
    for (final c in categories) {
      if (seen.add(c.name)) out.add(c);
    }
    return out;
  }
}
