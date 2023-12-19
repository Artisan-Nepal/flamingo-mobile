// ignore_for_file: unused_field

import 'package:flamingo/data/model/fetch_response.dart';
import 'package:flamingo/feature/auth/auth.dart';
import 'package:flamingo/feature/vendor/data/model/vendor.dart';
import 'package:flamingo/feature/vendor/data/vendor_repository.dart';
import 'package:flamingo/feature/vendor/data/local/vendor_local.dart';
import 'package:flamingo/feature/vendor/data/remote/vendor_remote.dart';

class VendorRepositoryImpl implements VendorRepository {
  final VendorLocal _vendorLocal;
  final VendorRemote _vendorRemote;
  final AuthRepository _authRepository;

  VendorRepositoryImpl({
    required VendorLocal vendorLocal,
    required VendorRemote vendorRemote,
    required AuthRepository authRepository,
  })  : _vendorLocal = vendorLocal,
        _authRepository = authRepository,
        _vendorRemote = vendorRemote;

  @override
  Future<FetchResponse<Vendor>> getVendors() async {
    return await _vendorRemote.getVendors();
  }
}
