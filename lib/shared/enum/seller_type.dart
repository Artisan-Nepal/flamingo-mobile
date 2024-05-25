// ignore_for_file: constant_identifier_names
enum SellerType { CUSTOMER, VENDOR }

extension SellerTypeGetters on SellerType {
  bool get isVendor => this == SellerType.VENDOR;
  bool get isCustomer => this == SellerType.CUSTOMER;
}

SellerType sellerTypeFromString(String sellerType) {
  return SellerType.values
      .firstWhere((e) => e.toString() == 'SellerType.$sellerType');
}
