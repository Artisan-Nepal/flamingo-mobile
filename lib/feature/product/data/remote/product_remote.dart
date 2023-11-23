import 'package:flamingo/data/data.dart';
import 'package:flamingo/feature/product/data/model/product.dart';

abstract class ProductRemote {
  Future<FetchResponse<Product>> getVendorProducts(String vendorId);
}
