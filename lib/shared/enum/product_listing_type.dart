enum ProductListingType { category, vendor, all }

extension ProductListingTypeGetters on ProductListingType {
  bool get isCategory => this == ProductListingType.category;
  bool get isVendor => this == ProductListingType.vendor;
  bool get isAll => this == ProductListingType.all;
}
