enum ProductListingType {
  category,
  vendor,
  all,
  advertisement,
}

extension ProductListingTypeGetters on ProductListingType {
  bool get isCategory => this == ProductListingType.category;
  bool get isVendor => this == ProductListingType.vendor;
  bool get isAdvertisement => this == ProductListingType.advertisement;
  bool get isAll => this == ProductListingType.all;
}
