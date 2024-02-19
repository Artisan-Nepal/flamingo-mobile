// ignore_for_file: constant_identifier_names
enum ProductType { CATEGORY, VENDOR, ALL, LATEST, FAVORITE_VENDOR, WISHLIST }

extension ProductTypeGetters on ProductType {
  bool get isCategory => this == ProductType.CATEGORY;
  bool get isVendor => this == ProductType.VENDOR;
  bool get isLatest => this == ProductType.LATEST;
  bool get isAll => this == ProductType.ALL;
}
