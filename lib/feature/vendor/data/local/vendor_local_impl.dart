import 'package:flamingo/data/local/local.dart';
import 'package:flamingo/feature/vendor/data/local/vendor_local.dart';

class VendorLocalImpl implements VendorLocal {
  // ignore: unused_field
  final LocalStorageClient _sharedPrefManager;

  VendorLocalImpl({required LocalStorageClient sharedPrefManager})
      : _sharedPrefManager = sharedPrefManager;
}
