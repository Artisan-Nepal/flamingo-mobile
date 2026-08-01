/// Buyer-facing product filters, mirrored on the backend
/// (see product-filter.ts). Serialized as query params for the seller/search
/// endpoints. Prices are in paisa (1 rupee = 100 paisa) to match the API.
class ProductFilterParams {
  final List<String> categoryIds;
  final List<String> sizeValues;
  final List<String> sellerIds;
  final bool onSale;
  final int? minPrice; // paisa
  final int? maxPrice; // paisa

  const ProductFilterParams({
    this.categoryIds = const [],
    this.sizeValues = const [],
    this.sellerIds = const [],
    this.onSale = false,
    this.minPrice,
    this.maxPrice,
  });

  bool get isEmpty =>
      categoryIds.isEmpty &&
      sizeValues.isEmpty &&
      sellerIds.isEmpty &&
      !onSale &&
      minPrice == null &&
      maxPrice == null;

  int get activeCount =>
      (categoryIds.isNotEmpty ? 1 : 0) +
      (sizeValues.isNotEmpty ? 1 : 0) +
      (sellerIds.isNotEmpty ? 1 : 0) +
      (onSale ? 1 : 0) +
      ((minPrice != null || maxPrice != null) ? 1 : 0);

  Map<String, String> toQueryParams() => {
        if (categoryIds.isNotEmpty) 'categoryIds': categoryIds.join(','),
        if (sizeValues.isNotEmpty) 'sizeValues': sizeValues.join(','),
        if (sellerIds.isNotEmpty) 'sellerIds': sellerIds.join(','),
        if (onSale) 'onSale': 'true',
        if (minPrice != null) 'minPrice': minPrice.toString(),
        if (maxPrice != null) 'maxPrice': maxPrice.toString(),
      };

  ProductFilterParams copyWith({
    List<String>? categoryIds,
    List<String>? sizeValues,
    List<String>? sellerIds,
    bool? onSale,
    int? minPrice,
    int? maxPrice,
    bool clearPrice = false,
  }) {
    return ProductFilterParams(
      categoryIds: categoryIds ?? this.categoryIds,
      sizeValues: sizeValues ?? this.sizeValues,
      sellerIds: sellerIds ?? this.sellerIds,
      onSale: onSale ?? this.onSale,
      minPrice: clearPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: clearPrice ? null : (maxPrice ?? this.maxPrice),
    );
  }
}
