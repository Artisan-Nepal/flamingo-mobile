enum ProductFilterType { priceAsc, priceDesc }

extension ProductFilterTypeGetters on ProductFilterType {
  bool get isPriceAsc => this == ProductFilterType.priceAsc;
  bool get isPriceDesc => this == ProductFilterType.priceDesc;
}
