import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/vendor/data/model/vendor.dart';

abstract class VendorRepository {
  Future<FetchResponse<Vendor>> getVendors();
}
