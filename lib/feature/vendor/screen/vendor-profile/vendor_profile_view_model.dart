import 'package:flamingo/feature/vendor/data/vendor_repository.dart';
import 'package:flutter/material.dart';

class VendorProfileViewModel extends ChangeNotifier {
  // ignore: unused_field
  final VendorRepository _vendorRepository;

  VendorProfileViewModel({required VendorRepository vendorRepository})
      : _vendorRepository = vendorRepository;
}
