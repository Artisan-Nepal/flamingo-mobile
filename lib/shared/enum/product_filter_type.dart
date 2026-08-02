enum ProductFilterType { priceAsc, priceDesc, newest, oldest, reset }

extension ProductFilterTypeGetters on ProductFilterType {
  bool get isPriceAsc => this == ProductFilterType.priceAsc;
  bool get isPriceDesc => this == ProductFilterType.priceDesc;
  bool get isNewest => this == ProductFilterType.newest;
  bool get isOldest => this == ProductFilterType.oldest;
  bool get isReset => this == ProductFilterType.reset;
}
