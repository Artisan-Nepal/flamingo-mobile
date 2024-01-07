enum ProductListingType {
  category,
  vendor,
  all,
  advertisement,
  latest,
}

extension ProductListingTypeGetters on ProductListingType {
  bool get isCategory => this == ProductListingType.category;
  bool get isVendor => this == ProductListingType.vendor;
  bool get isAdvertisement => this == ProductListingType.advertisement;
  bool get isLatest => this == ProductListingType.latest;
  bool get isAll => this == ProductListingType.all;
}
