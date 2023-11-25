// ignore_for_file: constant_identifier_names
enum VendorStatus { UNVERIFIED, VERIFIED }

VendorStatus vendorStatusFromString(String role) {
  return VendorStatus.values
      .firstWhere((e) => e.toString() == 'VendorStatus.$role');
}

extension VendorStatusGetters on VendorStatus {
  bool get isVerified => this == VendorStatus.VERIFIED;
  bool get isUnverified => this == VendorStatus.UNVERIFIED;
}
