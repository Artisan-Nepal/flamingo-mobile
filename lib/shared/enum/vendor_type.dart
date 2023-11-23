// ignore_for_file: constant_identifier_names

enum VendorType { LOCAL_VENDOR, BRAND_VENDOR }

VendorType vendorTypeFromString(String type) {
  return VendorType.values
      .firstWhere((e) => e.toString() == 'VendorType.$type');
}

extension VendorTypeGetters on VendorType {
  bool get isLocal => this == VendorType.LOCAL_VENDOR;
  bool get isBrand => this == VendorType.BRAND_VENDOR;
}
