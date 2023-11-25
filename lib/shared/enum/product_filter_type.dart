enum ProductFilterType { priceAsc, priceDesc, reset }

extension ProductFilterTypeGetters on ProductFilterType {
  bool get isPriceAsc => this == ProductFilterType.priceAsc;
  bool get isPriceDesc => this == ProductFilterType.priceDesc;
  bool get isReset => this == ProductFilterType.reset;
}
